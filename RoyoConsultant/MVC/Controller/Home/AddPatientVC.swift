//
//  AddPatientVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import SZTextView

class AddPatientVC: BaseVC {

    @IBOutlet weak var viewMedicalAllergies: UIView!
    @IBOutlet weak var viewImageSelection: UIView!
    @IBOutlet weak var viewChronicDiseses: UIView!
    @IBOutlet weak var viewMedication: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    @IBOutlet weak var tfEmail: JVFloatLabeledTextField!
    @IBOutlet weak var lblCC: UILabel!
    @IBOutlet weak var tfPhone: JVFloatLabeledTextField!
    @IBOutlet weak var lblRelationTitle: UILabel!
    @IBOutlet weak var collectionRelation: UICollectionView!
    @IBOutlet weak var collectionRelationHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRelation: UIView!
    @IBOutlet weak var tfRelation: JVFloatLabeledTextField!
    @IBOutlet weak var lblMedicalAllergies: UILabel!
    @IBOutlet weak var switchMedicalAllergies: UISegmentedControl!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDesc2: UILabel!
    @IBOutlet weak var tvMedicalAllergiesDesc: SZTextView!
    @IBOutlet weak var lblAnyChronicDisease: UILabel!
    @IBOutlet weak var switchAnyChronicDisease: UISegmentedControl!
    @IBOutlet weak var lblChooseChronic: UILabel!
    @IBOutlet weak var tableChronic: UITableView!
    @IBOutlet weak var tableChronicHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAnyPreviousSergeries: UILabel!
    @IBOutlet weak var switchPreviousSergeries: UISegmentedControl!
    @IBOutlet weak var lblPreviousMedication: UILabel!
    @IBOutlet weak var switchPreviousMedication: UISegmentedControl!
    @IBOutlet weak var tfMedicationName: JVFloatLabeledTextField!
    @IBOutlet weak var btnCreate: SKLottieButton!
    @IBOutlet weak var tvChronicDesc: SZTextView!
    @IBOutlet weak var viewSurgeryDesc: UIView!
    @IBOutlet weak var tfSurgeryDesc: SZTextView!
    @IBOutlet weak var lblSergeryDesc: UILabel!
    @IBOutlet weak var viewEmail: UIView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Disease>, DefaultCellModel<Disease>, Disease>?
    private var relationDataSource: CollectionDataSource?
    private var relations = [FamilyMemberType]()
    private var chronicDiseaes = Disease.getArray()
    private var image_URL: String?
    private var countryPicker: CountryManager?
    private var currentCountry: CountryISO?
    public var patientType: PatientType = .Children
    public var patiendAdded: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        relations = FamilyMemberType.getArray(type: patientType)
        lblCC.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(presentCountryPicker)))

        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectImage)))
        chronicDiseasesSetup()
        countryPicker = CountryManager()
        currentCountry = countryPicker?.currentCountry
        localizedTextSetUp()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 11: //Back
            popVC()
        case 13: //Create
            addFamilyAPI()
        default:
            break
        }
    }
    
    @IBAction func switchAction(_ sender: UISegmentedControl) {
        switch sender.tag {
        case 0: // Medical Allergies
            viewMedicalAllergies.isHidden = !(sender.selectedSegmentIndex == 0)
        case 1: // Chronic Diseases
            viewChronicDiseses.isHidden = !(sender.selectedSegmentIndex == 0)
        case 2: // Previous surgeries
            viewSurgeryDesc.isHidden = !(sender.selectedSegmentIndex == 0)
        case 3: // Previous Medication
            viewMedication.isHidden = !(sender.selectedSegmentIndex == 0)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension AddPatientVC {
    @objc private func presentCountryPicker() {
        countryPicker?.openCountryPicker({ [weak self] (country) in
            self?.currentCountry = country
            self?.lblCC.text = "\(/self?.currentCountry?.Flag) +\(/self?.currentCountry?.CC) - "
        })
    }
    
    @objc private func selectImage() {
        view.endEditing(true)
        mediaPicker.presentPicker({ [weak self] (image) in
            self?.imgView.image = image
            self?.uploadImageAPI()
        }, nil, nil)
    }
    
    private func chronicDiseasesSetup() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<Disease>, DefaultCellModel<Disease>, Disease>.init(.SingleListing(items: chronicDiseaes, identifier: DiseaseCell.identfier, height: 40.0, leadingSwipe: nil, trailingSwipe: nil), tableChronic)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? DiseaseCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            if /self?.switchAnyChronicDisease.selectedSegmentIndex == 1 {
                return
            }
            self?.chronicDiseaes.forEach({$0.isSelected = false})
            self?.chronicDiseaes[indexPath.row].isSelected = true
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.chronicDiseaes ?? []), .FullReload)
//            item?.property?.model?.isSelected = !(/item?.property?.model?.isSelected)
//            self?.tableChronic.reloadRows(at: [indexPath], with: .automatic)
        }
        
        tableChronicHeight.constant = /CGFloat(chronicDiseaes.count) * 40.0
    }
    
    private func addFamilyAPI() {
        let relation = relations.first(where: {/$0.isSelected})?.title?.localized == VCLiteral.OTHER.localized ? /tfRelation.text : /relations.first(where: {/$0.isSelected})?.title?.localized
        
        
//        let isValid = Validation.shared.validate(values: (.NAME, /tfName.text), (.EMAIL, /tfEmail.text), (.PHONE, /tfPhone.text), (.RELATION, /relation))
        let isValid = Validation.shared.validate(values: (.NAME, /tfName.text), (.RELATION, /relation))

        switch isValid {
        case .success:
            if /switchMedicalAllergies.selectedSegmentIndex == 0 && /tvMedicalAllergiesDesc.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                Toast.shared.showAlert(type: .validationFailure, message: AlertMessage.EMPTY_MEDICAL_ALLERGY.localized)
                btnCreate.vibrate()
                return
            } else if /switchAnyChronicDisease.selectedSegmentIndex == 0 &&  /chronicDiseaes.filter({/$0.isSelected}).count == 0 {
                Toast.shared.showAlert(type: .validationFailure, message: AlertMessage.SELECT_CHRONIC_DISESE_ALERT.localized)
                btnCreate.vibrate()
                return
            } else if /switchPreviousMedication.selectedSegmentIndex == 0 && /tfMedicationName.text == "" {
                Toast.shared.showAlert(type: .validationFailure, message: AlertMessage.EMPTY_MEDICATION_NAME.localized)
                btnCreate.vibrate()
                return
            }
        case .failure(let alert, let alertMessage):
            btnCreate.vibrate()
            Toast.shared.showAlert(type: alert, message: alertMessage.localized)
            return
        }

        let diseases: String? = chronicDiseaes.filter({/$0.isSelected}).map({/$0.title?.localized}).joined(separator: ", ")
        
        
        btnCreate.playAnimation()
        
        EP_Home.addFamily(firstName: tfName.text, lastName: "", relation: relation, gender: nil, age: nil, height: nil, weight: nil, blood_group: nil, image: nil, optionals: "gender", medical_allergies: tvMedicalAllergiesDesc.text, chronic_diseases: diseases, previous_surgeries: switchPreviousSergeries.selectedSegmentIndex == 0 ? /tfSurgeryDesc.text : nil, previous_medication: tfMedicationName.text, country_code: "+\(/currentCountry?.CC)", email: tfEmail.text, phone: tfPhone.text, patient_type: patientType, chronic_diseases_desc: tvChronicDesc.text.trimmingCharacters(in: .whitespacesAndNewlines)).request { [weak self] (responseData) in
            if let newMember = responseData as? FamilyMember {
                let tempData = UserPreference.shared.data
                var members = tempData?.family_members ?? []
                members.append(newMember)
                tempData?.family_members = members
                UserPreference.shared.data = tempData
            }
            self?.btnCreate.stop()
            self?.popVC()
            self?.patiendAdded?()
        } error: { [weak self] (error) in
            self?.btnCreate.stop()
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
    
    private func localizedTextSetUp() {
        
        viewImageSelection.isHidden = true
        
        lblTitle.text = VCLiteral.ADD_A_PATIENT.localized
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
        tfEmail.placeholder = VCLiteral.EMAIL_PLACEHOLDER.localized
        tfPhone.placeholder = VCLiteral.PHONE_NUMBER.localized
        lblRelationTitle.text = VCLiteral.RELATION.localized
        collectionRelationSetup()
        tfRelation.placeholder = VCLiteral.RELATION.localized
        viewRelation.isHidden = true
        btnCreate.setTitle(VCLiteral.ADD_A_PATIENT.localized, for: .normal)
        lblMedicalAllergies.text = VCLiteral.MEDICAL_ALLERGIES.localized
        lblDesc.text = VCLiteral.DESCRIPTION.localized
        lblDesc2.text = VCLiteral.DESCRIPTION.localized
        lblAnyChronicDisease.text = VCLiteral.CHRONIC_DISEASE.localized
        lblAnyPreviousSergeries.text = VCLiteral.PREVIOUS_SURGERIES.localized
        lblPreviousMedication.text = VCLiteral.PREVIOUS_MEDICATION.localized
        tfMedicationName.placeholder = VCLiteral.MEDICATION_NAME.localized
        lblSergeryDesc.text = VCLiteral.DESCRIPTION.localized
        lblCC.text = "\(/currentCountry?.Flag) +\(/currentCountry?.CC) - "
        
        
        
        [switchMedicalAllergies, switchAnyChronicDisease, switchPreviousSergeries, switchPreviousMedication].forEach { (segment) in
            segment?.selectedSegmentIndex = 1
            segment?.setTitle(VCLiteral.YES.localized, forSegmentAt: 0)
            segment?.setTitle(VCLiteral.NO.localized, forSegmentAt: 1)
        }
        
        viewMedicalAllergies.isHidden = true
        viewChronicDiseses.isHidden = true
        viewMedication.isHidden = true
        viewSurgeryDesc.isHidden = true
        viewEmail.isHidden = true
        
        if L102Language.isRTL {
            tvChronicDesc.makeTextWritingDirectionRightToLeft(true)
            tvMedicalAllergiesDesc.makeTextWritingDirectionRightToLeft(true)
        }

    }
    
    private func collectionRelationSetup() {
        let width = (((UIScreen.main.bounds.width - 32) - 32) / 3) - 0.5
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: 36), interItemSpacing: 16, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        collectionRelationHeight.constant = sizeProvider.getHeightOfTableViewCell(for: relations.count, gridCount: 3)
        
        relationDataSource = CollectionDataSource.init(relations, VendorFilterCell.identfier, collectionRelation, sizeProvider.cellSize, sizeProvider.edgeInsets, sizeProvider.lineSpacing, sizeProvider.interItemSpacing, .vertical)
        
        relationDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorFilterCell)?.relation = item as? FamilyMemberType
        }
        
        relationDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if /self?.relations[indexPath.item].isSelected {
                self?.relations[indexPath.item].isSelected = false
            } else {
                self?.relations.forEach({$0.isSelected = false})
                self?.relations[indexPath.item].isSelected = true
            }
            self?.viewRelation.isHidden = !(self?.relations.first(where: {/$0.isSelected})?.title == .OTHER)
            self?.relationDataSource?.updateData(self?.relations)
        }
        
    }
}
