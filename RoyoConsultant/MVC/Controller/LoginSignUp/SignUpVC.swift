//
//  SignUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView
import JVFloatLabeledTextField

class SignUpVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfDOB: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tfPsw: JVFloatLabeledTextField!
    @IBOutlet weak var tfReEnterPsw: JVFloatLabeledTextField!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblAlreadyRegister: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblBySigningUp: UILabel!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewLottie: UIView!
    @IBOutlet weak var viewBio: UIView!
    @IBOutlet weak var tvbio: SZTextView!
    @IBOutlet weak var tfNationality: JVFloatLabeledTextField!
    @IBOutlet weak var tfGender: JVFloatLabeledTextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewNationality: UIView!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var viewInvite: UIView!
    @IBOutlet weak var tfInvite: JVFloatLabeledTextField!
    @IBOutlet weak var btnTick: UIButton!
    
    private var dob: Date?
    private var image_URL: String?
    private var gender: GenderOption?
    private var countryPicker: SKGenericPicker<PickerCountryModel>?
    private var currentCountry: CountryBackend?
    private var isTermsAgreed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfResponder = TFResponder.init()
        #if HealthCarePrashant
        tfResponder?.addResponders([.TF(tfName), .TF(tfEmail), .TF(tfPsw), .TF(tfReEnterPsw)])
        #else
        tfResponder?.addResponders([.TF(tfName), .TF(tfDOB), .TF(tfEmail), .TF(tfPsw), .TF(tfReEnterPsw)])
        #endif
        localizedTextSetup()
        tfDOB.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date().dateBySubtractingMonths(5 * 12), minDate: nil, configureDate: { [weak self] (selectedDate) in
            self?.tfDOB.text = selectedDate.toString(DateFormat.custom(UserPreference.shared.dateFormat), isForAPI: false)
            self?.dob = selectedDate
        })
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
        tfPsw.textContentType = .password
        tfReEnterPsw.textContentType = .password
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Login
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .phone
            pushVC(destVC)
        case 2: //Next
            view.endEditing(true)
            #if HealthCarePrashant
            let isValid = Validation.shared.validate(values: (.NAME, /tfName.text), (.EMAIL, /tfEmail.text), (.PASSWORD, /tfPsw.text), (.ReEnterPassword, /tfReEnterPsw.text))
            #else
            let isValid = Validation.shared.validate(values: (.NAME, /tfName.text), (.DOB, /tfDOB.text), (.EMAIL, /tfEmail.text), (.PASSWORD, /tfPsw.text), (.ReEnterPassword, /tfReEnterPsw.text))
            #endif
            switch isValid {
            case .success:
                if /tfPsw.text == /tfReEnterPsw.text {
                    if isTermsAgreed {
                        registerAPI()
                    } else {
                        Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.TERMS_ALERT.localized)
                    }
                } else {
                    Toast.shared.showAlert(type: .validationFailure, message: AlertMessage.PASSWORD_NOT_MATCHED.localized)
                }
            case .failure(let alertType, let meessage):
                Toast.shared.showAlert(type: alertType, message: meessage.localized)
            }
        case 3: //Terms of Service
            openTermsAndConditionsScreen()
        case 4: //Privacy Policy
            openPrivacyPolicyScreen()
        case 5: //Tick Terms
            isTermsAgreed = !(isTermsAgreed)
            btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
            btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension SignUpVC {
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
        }, nil, nil)
    }
    
    private func registerAPI() {
        startAnimation()
        
        var preferencesToSend = [PreferenceToSend]()
        var filters = [Filter]()
        if let genderFilter = UserPreference.shared.masterPrefs?.getGenderPreference(), let option = gender?.model {
            option.isSelected = true
            genderFilter.options = [option]
            filters.append(genderFilter)
        }
        
        filters.forEach({ (filter) in
            if /filter.options?.contains(where: {/$0.isSelected}) {
                let ids = ((filter.options)?.filter({/$0.isSelected}) ?? []).compactMap({/$0.id})
                preferencesToSend.append(PreferenceToSend.init(filter.id, ids))
            }
        })
        let jsonFilters = JSONHelper<[PreferenceToSend]>().toJSONString(model: preferencesToSend)
        
        let registerEP = EP_Login.register(name: /tfName.text, email: /tfEmail.text, password: /tfPsw.text, phone: nil, code: nil, user_type: .customer, fcm_id: UserPreference.shared.firebaseToken, country_code: nil, dob: /dob?.toString(DateFormat.custom("yyyy-MM-dd"), isForAPI: true), bio: tvbio.text.trimmingCharacters(in: .whitespacesAndNewlines), profile_image: image_URL, master_preferences: jsonFilters, countryId: currentCountry?.id, invite_code: tfInvite.text, is_agreed: true)
        
        #if NurseLynx || HomeDoctorKhalid
        EP_Login.sendEmailOTP(email: /tfEmail.text).request { [weak self] (response) in
            self?.stopAnimation()
            let destVC = Storyboard<VerificationVC>.LoginSignUp.instantiateVC()
            destVC.email = /self?.tfEmail.text
            destVC.registerEP = registerEP
            destVC.verifyType = .AccountCreation
            destVC.providerType = .email
            self?.pushVC(destVC)
        } error: { [weak self] error in
            self?.stopAnimation()
        }
        
        #else
        registerEP.request(success: { [weak self] (response) in
            self?.stopAnimation()
            if /UserPreference.shared.clientDetail?.openAddressInsuranceScreen() {
                self?.pushVC(Storyboard<AddressInsuranceVC>.LoginSignUp.instantiateVC())
            } else {
                UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
            }
        }) { [weak self] (error) in
            self?.stopAnimation()
        }
        #endif
    }
    
    private func getCountriesAPI() {
        EP_Home.getCountryStateCity(type: .country, countryId: nil, stateId: nil).request(success: { [weak self] (responseData) in
            let response = responseData as? CountryStateCityData
            self?.countryPicker?.updateItems(response?.getCountries())
        })
    }
    
    private func uploadImageAPI() {
        playUploadAnimation(on: imgView)
        EP_Home.uploadImage(image: (imgView.image)!, type: .image, doc: nil, localAudioPath: nil).request(success: { [weak self] (responseData) in
            self?.stopUploadAnimation()
            self?.image_URL = (responseData as? ImageUploadData)?.image_name
        }) { [weak self] (error) in
            self?.stopUploadAnimation()
            self?.alertBox(title: VCLiteral.UPLOAD_ERROR.localized, message: error, btn1: VCLiteral.CANCEL.localized, btn2: VCLiteral.RETRY.localized, tapped1: {
                self?.imgView.image = nil
            }, tapped2: {
                self?.uploadImageAPI()
            })
        }
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.SIGNUP.localized
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfDOB.placeholder = VCLiteral.DOB_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tfPsw.placeholder = VCLiteral.PSW_PLACEHOLDER.localized
        tfReEnterPsw.placeholder = VCLiteral.ReEnterPsw_PLACEHOLDER.localized
        lblAlreadyRegister.text =  VCLiteral.ALREADY_REGISTER.localized
        btnLogin.setTitle(VCLiteral.LOGIN.localized, for: .normal)
        lblBySigningUp.text = VCLiteral.BY_SIGNING_UP.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
        lblAnd.text = VCLiteral.AND.localized
        btnPrivacyPolicy.setTitle(VCLiteral.PRIVACY.localized, for: .normal)
        tvbio.placeholder = VCLiteral.BIO_PLACEHOLDER.localized
        tfInvite.placeholder = VCLiteral.INVITE_CODE.localized
        viewInvite.isHidden = !(/UserPreference.shared.clientDetail?.invite_enabled)
        tfInvite.isEnabled = /UserPreference.shared.clientDetail?.invite_enabled
        
        tfGender.placeholder = VCLiteral.GENDER.localized
        tfNationality.placeholder = VCLiteral.NATIONALITY.localized
        
        #if HealthCarePrashant
        viewGender.isHidden = true
        tfGender.isEnabled = true
        #else
        viewGender.isHidden = UserPreference.shared.masterPrefs?.getGenderPreference() == nil
        tfGender.isEnabled = UserPreference.shared.masterPrefs?.getGenderPreference() != nil
        #endif
        
        var array = [GenderOption]()
        UserPreference.shared.masterPrefs?.getGenderPreference()?.options?.forEach({ (option) in
            array.append(GenderOption.init(option.option_name, option))
        })
        tfGender.inputView = SKGenericPicker<GenderOption>.init(frame: .zero, items: array, configureItem: { [weak self] (selectedGender) in
            self?.gender = selectedGender
            self?.tfGender.text = /selectedGender?.title
        })
        
        countryPicker = SKGenericPicker<PickerCountryModel>.init(frame: CGRect.zero, items: [], configureItem: { [weak self] (countryModel) in
            self?.currentCountry = countryModel?.model
            self?.tfNationality.text = /countryModel?.title
        })
        
        tfNationality.inputView = countryPicker
        
        if L102Language.isRTL {
            tvbio.makeTextWritingDirectionRightToLeft(true)
        }
        
        btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
        
        #if HealthCarePrashant
        viewBio.isHidden = true
        viewNationality.isHidden = true
        tfNationality.isEnabled = false
        viewDOB.isHidden = true
        tfDOB.isEnabled = false
        #elseif Heal
        viewNationality.isHidden = false
        tfNationality.isEnabled = true
        getCountriesAPI()
        #else
        viewBio.isHidden = false
        viewNationality.isHidden = true
        tfNationality.isEnabled = false
        #endif
        
    }
    
    private func startAnimation() {
        view.isUserInteractionEnabled = false
        lblAlreadyRegister.isHidden = true
        btnLogin.isHidden = true
        btnNext.isHidden = true
        dotsAnimationView.frame = viewLottie.bounds
        viewLottie.addSubview(dotsAnimationView)
        viewLottie.isHidden = false
        dotsAnimationView.play()
    }
    
    private func stopAnimation() {
        dotsAnimationView.stop()
        dotsAnimationView.removeFromSuperview()
        view.isUserInteractionEnabled = true
        viewLottie.isHidden = true
        
        lblAlreadyRegister.isHidden = false
        btnLogin.isHidden = false
        btnNext.isHidden = false
    }
}
