//
//  EditProfileVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SZTextView

class EditProfileVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfDOB: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var tvBio: SZTextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnUpdate: SKButton!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var tfGender: JVFloatLabeledTextField!
    @IBOutlet weak var tfNationality: JVFloatLabeledTextField!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewNationality: UIView!
    @IBOutlet weak var viewBio: UIView!
    @IBOutlet weak var viewDOB: UIView!
    
    @IBOutlet weak var tfNationalityId: UITextField!
    @IBOutlet weak var viewNationalityId: UIView!
    private var image_URL: String?
    private var dob: String?
    private var gender: GenderOption?
    private var countryPicker: SKGenericPicker<PickerCountryModel>?
    private var currentCountry: CountryBackend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        initialDataSet()
        
        tfDOB.inputView = SKDatePicker.init(frame: .zero, mode: .date, maxDate: Date().dateBySubtractingMonths(5 * 12), minDate: nil, configureDate: { [weak self] (selectedDate) in
            self?.dob = selectedDate.toString(DateFormat.custom("yyyy-MM-dd"), isForAPI: true)
            self?.tfDOB.text = selectedDate.toString(DateFormat.custom(UserPreference.shared.dateFormat), isForAPI: false)
        })
        
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Update
            updateProfileAPI()
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension EditProfileVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.EDIT_PROFILE.localized
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfDOB.placeholder = VCLiteral.DOB_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tfNationalityId.placeholder = VCLiteral.NATIONAL_ID_NUMBER.localized
        lblBio.text = VCLiteral.BIO_PLACEHOLDER.localized
        btnUpdate.setTitle(VCLiteral.UPDATE.localized, for: .normal)
        
        switch UserPreference.shared.data?.provider_type ?? .phone {
        case .facebook, .google, .apple:
            tfEmail.isUserInteractionEnabled = false
        default:
            tfEmail.isUserInteractionEnabled = true
        }
        
        if L102Language.isRTL {
            tvBio.makeTextWritingDirectionRightToLeft(true)
        }
        
        tfGender.placeholder = VCLiteral.GENDER.localized
        tfNationality.placeholder = VCLiteral.NATIONALITY.localized
        
        #if HealthCarePrashant
        viewGender.isHidden = true
        tfGender.isEnabled = true
        #else
        viewGender.isHidden = UserPreference.shared.masterPrefs?.getGenderPreference() == nil
        tfGender.isEnabled = UserPreference.shared.masterPrefs?.getGenderPreference() != nil
        #endif
     
        #if HomeDoctorKhalid
        viewNationalityId.isHidden = false
        #else
        viewNationalityId.isHidden = true
        #endif
        
        var array = [GenderOption]()
        UserPreference.shared.masterPrefs?.getGenderPreference()?.options?.forEach({ (option) in
            array.append(GenderOption.init(option.option_name, option))
        })
        
        gender = array.first(where: {/$0.model?.id == /UserPreference.shared.data?.master_preferences?.getGenderPreference()?.options?.first?.id})
        tfGender.text = /gender?.title
        
        tfGender.inputView = SKGenericPicker<GenderOption>.init(frame: .zero, items: array, configureItem: { [weak self] (selectedGender) in
            self?.gender = selectedGender
            self?.tfGender.text = /selectedGender?.title
        })
        
        countryPicker = SKGenericPicker<PickerCountryModel>.init(frame: CGRect.zero, items: [], configureItem: { [weak self] (countryModel) in
            self?.currentCountry = countryModel?.model
            self?.tfNationality.text = /countryModel?.title
        })
        
        tfNationality.inputView = countryPicker
        
        #if Heal
        viewNationality.isHidden = false
        tfNationality.isEnabled = true
        viewBio.isHidden = false
        getCountriesAPI()
        #elseif HealthCarePrashant
        viewNationality.isHidden = true
        tfNationality.isEnabled = false
        viewBio.isHidden = true
        viewDOB.isHidden = true
        tfDOB.isEnabled = false
        #elseif NurseLynx
        viewNationality.isHidden = false
        tfNationality.isEnabled = true
        viewBio.isHidden = false
        getCountriesAPI()
        #else
        viewBio.isHidden = false
        viewNationality.isHidden = true
        tfNationality.isEnabled = false
        #endif
    }
    
    private func initialDataSet() {
        let user = UserPreference.shared.data
        tfName.text = /user?.name
        tfEmail.text = /user?.email
        tfDOB.text = /user?.profile?.dob == "" ? nil : Date.init(fromString: /user?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom(UserPreference.shared.dateFormat), timeZone: .local, isForAPI: false)
        tvBio.text = /user?.profile?.bio
        imgView.setImageNuke(/user?.profile_image, placeHolder: nil)
        tfNationalityId.text = /user?.national_id
    }
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
        }, nil, nil)
    }
    
    private func getCountriesAPI() {
        EP_Home.getCountryStateCity(type: .country, countryId: nil, stateId: nil).request(success: { [weak self] (responseData) in
            let response = responseData as? CountryStateCityData
            self?.currentCountry = response?.getCountries().first(where: {/String(/$0.model?.id) == /UserPreference.shared.data?.profile?.country_id})?.model
            self?.tfNationality.text = /self?.currentCountry?.name
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
        if !viewNationalityId.isHidden && tfNationalityId.text == "" {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.ALERT_NATIONAL_ID.localized)
            return
        }
        filters.forEach({ (filter) in
            if /filter.options?.contains(where: {/$0.isSelected}) {
                let ids = ((filter.options)?.filter({/$0.isSelected}) ?? []).compactMap({/$0.id})
                preferencesToSend.append(PreferenceToSend.init(filter.id, ids))
            }
        })
        let jsonFilters = JSONHelper<[PreferenceToSend]>().toJSONString(model: preferencesToSend)
        
        btnUpdate.playAnimation()
        EP_Login.profileUpdate(name: tfName.text, email: tfEmail.text, phone: nil, country_code: nil, dob: dob, bio: tvBio.text, speciality: nil, call_price: nil, chat_price: nil, category_id: nil, experience: nil, profile_image: image_URL, master_preferences: jsonFilters, countryId: currentCountry?.id, invite_Code: nil, is_agreed: true, national_id: tfNationalityId.text).request(success: { [weak self] (response) in
            self?.view.isUserInteractionEnabled = true
            self?.btnUpdate.stop()
            if /UserPreference.shared.clientDetail?.openAddressInsuranceScreen() {
                let destVC = Storyboard<AddressInsuranceVC>.LoginSignUp.instantiateVC()
                destVC.isUpdating = true
                self?.pushVC(destVC)
            } else {
                self?.popVC()
            }
        }) { [weak self] (error) in
            self?.view.isUserInteractionEnabled = true
            self?.btnUpdate.stop()
        }
    }
}
