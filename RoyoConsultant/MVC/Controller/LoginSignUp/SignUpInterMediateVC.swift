//
//  SignUpInterMediateVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView
import JVFloatLabeledTextField

class SignUpInterMediateVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfDOB: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tvBio: SZTextView!
    @IBOutlet weak var viewBio: UIView!
    @IBOutlet weak var tfGender: JVFloatLabeledTextField!
    @IBOutlet weak var tfNationality: JVFloatLabeledTextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewNationality: UIView!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var viewInvite: UIView!
    @IBOutlet weak var tfInvite: JVFloatLabeledTextField!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var lblBySigningUp: UILabel!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var viewTermsAndConditions: UIStackView!
    
    @IBOutlet weak var viewNationalId: UIView!
    
    private var dob: Date?
    private var image_URL: String?
    private var gender: GenderOption?
    private var countryPicker: SKGenericPicker<PickerCountryModel>?
    private var currentCountry: CountryBackend?
    private var isTermsAgreed = false

    @IBOutlet weak var tfNationalId: UITextField!
    
    public var isViaSocialLogin: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton()
            btn.tag = 1
            self?.btnAction(btn)
        }
        
        tfResponder = TFResponder()
        #if HealthCarePrashant
        tfResponder?.addResponders([.TF(tfName), .TF(tfEmail)])
        #else
        tfResponder?.addResponders([.TF(tfName), .TF(tfDOB), .TF(tfEmail)])
        #endif
        
        #if HomeDoctorKhalid
        viewNationalId.isHidden = false
        #else
        viewNationalId.isHidden = true
        #endif
        tfDOB.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date().dateBySubtractingMonths(5 * 12), minDate: nil, configureDate: { [weak self] (selectedDate) in
            self?.dob = selectedDate
            self?.tfDOB.text = selectedDate.toString(DateFormat.custom(UserPreference.shared.dateFormat), isForAPI: false)
        })
        
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
        
        #if NurseLynx
        viewTermsAndConditions.isHidden = false
        isTermsAgreed = false
        #else
        viewTermsAndConditions.isHidden = true
        isTermsAgreed = true
        #endif
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return nextBtnAccessory
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Next
            switch Validation.shared.validate(values: (ValidationType.NAME, /tfName.text)) {
            case .success:
                if !viewNationalId.isHidden && tfNationalId.text == "" {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.ALERT_NATIONAL_ID.localized)
                }
                if isTermsAgreed {
                    updateProfileAPI()
                } else {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.TERMS_ALERT.localized)
                }
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
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
extension SignUpInterMediateVC {
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
        }, nil, nil)
    }
    
    private func updateProfileAPI() {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        
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
        
        nextBtnAccessory.startAnimation()
        EP_Login.profileUpdate(name: tfName.text, email: tfEmail.text, phone: UserPreference.shared.data?.phone, country_code: UserPreference.shared.data?.country_code, dob: dob?.toString(DateFormat.custom("yyyy-MM-dd"), isForAPI: true), bio: tvBio.text.trimmingCharacters(in: .whitespacesAndNewlines), speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: image_URL, master_preferences: jsonFilters, countryId: currentCountry?.id, invite_Code: tfInvite.text, is_agreed: true, national_id: tfNationalId.text).request(success: { [weak self] (response) in
            
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
            if /UserPreference.shared.clientDetail?.openAddressInsuranceScreen() {
                self?.pushVC(Storyboard<AddressInsuranceVC>.LoginSignUp.instantiateVC())
                return
            } else {
                UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.nextBtnAccessory.stopAnimation()
        }
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
    
    private func getCountriesAPI() {
        EP_Home.getCountryStateCity(type: .country, countryId: nil, stateId: nil).request(success: { [weak self] (responseData) in
            let response = responseData as? CountryStateCityData
            self?.countryPicker?.updateItems(response?.getCountries())
        })
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.SIGNUP.localized
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfDOB.placeholder = VCLiteral.DOB_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tvBio.placeholder = VCLiteral.BIO_PLACEHOLDER.localized
        tfGender.placeholder = VCLiteral.GENDER.localized
        tfNationalId.placeholder = VCLiteral.NATIONAL_ID_NUMBER.localized
        
        tfNationality.placeholder = VCLiteral.NATIONALITY.localized
        tfInvite.placeholder = VCLiteral.INVITE_CODE.localized
        viewInvite.isHidden = !(/UserPreference.shared.clientDetail?.invite_enabled)
        tfInvite.isEnabled = /UserPreference.shared.clientDetail?.invite_enabled
        
        lblBySigningUp.text = VCLiteral.BY_SIGNING_UP.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
        lblAnd.text = VCLiteral.AND.localized
        btnPrivacyPolicy.setTitle(VCLiteral.PRIVACY.localized, for: .normal)
        
        btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
        
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
            tvBio.makeTextWritingDirectionRightToLeft(true)
        }

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
        #elseif NurseLynx
        viewBio.isHidden = false
        viewNationality.isHidden = false
        tfNationality.isEnabled = true
        getCountriesAPI()
        #else
        viewBio.isHidden = false
        viewNationality.isHidden = true
        tfNationality.isEnabled = false
        #endif
        
        
        if /isViaSocialLogin {
            tfName.text = /UserPreference.shared.socialLoginData?.name
            tfEmail.text = /UserPreference.shared.socialLoginData?.email
            tfEmail.isUserInteractionEnabled = /UserPreference.shared.socialLoginData?.email == ""
            imgView.setImage(from: UserPreference.shared.socialLoginData?.imageURL, placeHolder: nil)
        }
    }
}
