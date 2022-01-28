//
//  AddressInsuranceVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 21/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class AddressInsuranceVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfAddress: JVFloatLabeledTextField!
    @IBOutlet weak var tfState: JVFloatLabeledTextField!
    @IBOutlet weak var tfCity: JVFloatLabeledTextField!
    @IBOutlet weak var tfZip: JVFloatLabeledTextField!
    @IBOutlet weak var lblYes: UILabel!
    @IBOutlet weak var lblDoYoHaveInsurance: UILabel!
    @IBOutlet weak var lblIfYes: UILabel!
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblSelectInsurance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTerms1: UILabel!
    @IBOutlet weak var lblTerms2: UILabel!
    @IBOutlet weak var lblTerms3: UILabel!
    @IBOutlet weak var btnSubmit: SKLottieButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnTerms1: UIButton!
    @IBOutlet weak var btnTerms2: UIButton!
    @IBOutlet weak var btnTerms3: UIButton!
    @IBOutlet weak var stackCityZip: UIStackView!
    
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewZip: UIView!
    @IBOutlet weak var viewInsurace: UIView!
    @IBOutlet weak var viewTerms1: UIView!
    @IBOutlet weak var viewTerms2: UIView!
    @IBOutlet weak var viewTerms3: UIView!
    @IBOutlet weak var viewSubInsurance: UIView!
    
    @IBOutlet weak var lblInsuranceInfo: UILabel!
    @IBOutlet weak var btnadd: UIButton!
    @IBOutlet weak var tableViewInsuranceInfo: UITableView!
    @IBOutlet weak var heightInsuranceInfo: NSLayoutConstraint!
    @IBOutlet weak var viewInsuranceInfo: UIView!
    
    private var hadInsurance = false
    private var termsSelected: (terms1: Bool, terms2: Bool, terms3: Bool) = (false, false, false)
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Insurance>, DefaultCellModel<Insurance>,Insurance>?
    private var dataSourceInsuranceInfo: TableDataSource<DefaultHeaderFooterModel<InsuranceInfo>, DefaultCellModel<InsuranceInfo>, InsuranceInfo>?
    
    private var insurances = UserPreference.shared.clientDetail?.insurances
    private var insuranceInfos = [InsuranceInfo]()
    private var isMultiSelectionOfInsurances = false
    private var statePicker: SKGenericPicker<PickerStateModel>?
    private var cityPicker: SKGenericPicker<PickerCityModel>?
    private var currentState: State?
    private var currentCity: City?
    
    public var isUpdating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputViews()
        localizedTextSetup()
        configureTableView()
        configureInsuranceInfos()
        if let countryId = UserPreference.shared.clientDetail?.country_id {
            getCountryStateCityAPI(type: .state, countryId: countryId, stateId: nil)
        }
        initialSetupWhileEditing()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Insurance Yes
            hadInsurance = true
            switchYesNo()
        case 2: //Insurance No
            hadInsurance = false
            switchYesNo()
            insurances?.forEach({$0.isSelected = false})
            dataSource?.updateAndReload(for: .SingleListing(items: insurances ?? []), .FullReload)
        case 3: //Terms 1 Tick
            termsSelected.terms1.toggle()
            toggleTerms()
        case 4: //Terms 2 Tick
            termsSelected.terms2.toggle()
            toggleTerms()
        case 5: //Terms 3 Tick
            termsSelected.terms3.toggle()
            toggleTerms()
        case 6: //Submit
            validateValues()
        case 7: //Add Insurance Info
            let destVC = Storyboard<UploadInsuranceVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.didTapAdd = { [weak self] (insurance) in
                self?.insuranceInfos.insert(insurance!, at: 0)
                self?.dataSourceInsuranceInfo?.updateAndReload(for: .SingleListing(items: self?.insuranceInfos ?? []), .FullReload)
                let totalHeight = /CGFloat(/self?.insuranceInfos.count * 80)
                self?.heightInsuranceInfo.constant = totalHeight
                self?.btnadd.isHidden = true
            }
            presentPopUp(destVC)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension AddressInsuranceVC {
    private func setupInputViews() {
        statePicker = SKGenericPicker<PickerStateModel>.init(frame: CGRect.zero, items: [], configureItem: { [weak self] (state) in
            self?.currentState = state?.model
            self?.tfState.text = /state?.title
            self?.currentCity = nil
            self?.tfCity.text = nil
            self?.getCountryStateCityAPI(type: .city, countryId: UserPreference.shared.clientDetail?.country_id, stateId: state?.model?.id)
        })
        tfState.inputView = statePicker
        
        cityPicker = SKGenericPicker<PickerCityModel>.init(frame: CGRect.zero, items: [], configureItem: { [weak self] (city) in
            self?.currentCity = city?.model
            self?.tfCity.text = /city?.title
        })
        
        tfCity.inputView = cityPicker
    }
    
    private func localizedTextSetup() {
        lblTitle.text = isUpdating ? VCLiteral.UPDATE.localized : VCLiteral.START_JOURNEY.localized
        tfAddress.placeholder = VCLiteral.ADDRESS.localized
        tfState.placeholder = VCLiteral.STATE.localized
        tfCity.placeholder = VCLiteral.CITY.localized
        tfZip.placeholder = VCLiteral.ZIP.localized
        lblDoYoHaveInsurance.text = VCLiteral.DO_YOU_HAVE_INSURANCE.localized
        lblYes.text = VCLiteral.YES.localized
        lblNo.text = VCLiteral.NO.localized
        lblIfYes.text = VCLiteral.IF_YES_WHAT_INSURANCE.localized
        lblSelectInsurance.text = VCLiteral.SELECT_INSURANCE.localized
        lblTerms1.text = VCLiteral.INSURANCE_TERMS_1.localized
        lblTerms2.text = VCLiteral.INSURANCE_TERMS_2.localized
        lblTerms3.text = VCLiteral.INSURANCE_TERMS_3.localized
        btnadd.setTitle(VCLiteral.ADD.localized, for: .normal)
        lblInsuranceInfo.text = VCLiteral.INSURANCE_INFO.localized
        
        viewInsurace.isHidden = !(/UserPreference.shared.clientDetail?.hasInsurance())
        viewZip.isHidden = /UserPreference.shared.clientDetail?.hasAddress() ? !(/UserPreference.shared.clientDetail?.hasZipCode(for: .customer)) : true
        viewAddress.isHidden = !(/UserPreference.shared.clientDetail?.hasAddress())
        viewState.isHidden = !(/UserPreference.shared.clientDetail?.hasAddress())
        viewCity.isHidden = !(/UserPreference.shared.clientDetail?.hasAddress())
        stackCityZip.isHidden = viewCity.isHidden && viewZip.isHidden
        
        switchYesNo()
        toggleTerms()
    }
    
    private func initialSetupWhileEditing() {
        tfAddress.text = /UserPreference.shared.data?.profile?.address
        tfState.text = /UserPreference.shared.data?.profile?.state
        tfCity.text = /UserPreference.shared.data?.profile?.city
        tfZip.text = /UserPreference.shared.data?.custom_fields?.first(where: {/$0.field_name == "Zip Code"})?.field_value
        
        insurances?.forEach({ (insurance) in
            insurance.isSelected = /UserPreference.shared.data?.insurances?.contains(where: {/$0.id == /insurance.id})
        })
        
        dataSource?.updateAndReload(for: .SingleListing(items: insurances ?? []), .FullReload)
        
        hadInsurance = /UserPreference.shared.data?.insurances?.count != 0
        switchYesNo()
        
        currentCity = City(Int(/UserPreference.shared.data?.profile?.city_id), UserPreference.shared.data?.profile?.city)
        currentState = State(Int(/UserPreference.shared.data?.profile?.state_id), UserPreference.shared.data?.profile?.state)
        
        if let stateId = UserPreference.shared.data?.profile?.state_id {
            if stateId == "" {
                return
            }
            getCountryStateCityAPI(type: .city, countryId: UserPreference.shared.clientDetail?.country_id, stateId: Int(/stateId))
        }
    }
    
    private func switchYesNo() {
        btnYes.backgroundColor = hadInsurance ? ColorAsset.appTint.color : UIColor.clear
        btnYes.setImage(hadInsurance ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        btnNo.backgroundColor = hadInsurance ? UIColor.clear : ColorAsset.appTint.color
        btnNo.setImage(hadInsurance ? nil : #imageLiteral(resourceName: "ic_tick"), for: .normal)
        viewSubInsurance.isHidden = !hadInsurance
        viewInsuranceInfo.isHidden = !hadInsurance
        let maxHeight = CGFloat(40 * 10)
        let totalHeight = /CGFloat(/insurances?.count * 40)
        tableHeight.constant = hadInsurance ? (totalHeight >= maxHeight ? maxHeight : totalHeight) : 0
    }
    
    private func toggleTerms() {
        btnTerms1.backgroundColor = termsSelected.terms1 ? ColorAsset.appTint.color : UIColor.clear
        btnTerms1.setImage(termsSelected.terms1 ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        btnTerms2.backgroundColor = termsSelected.terms2 ? ColorAsset.appTint.color : UIColor.clear
        btnTerms2.setImage(termsSelected.terms2 ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        btnTerms3.backgroundColor = termsSelected.terms3 ? ColorAsset.appTint.color : UIColor.clear
        btnTerms3.setImage(termsSelected.terms3 ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
    }
    
    private func configureTableView() {
        
        let maxHeight = CGFloat(40 * 10)
        let totalHeight = /CGFloat(/insurances?.count * 40)
        tableHeight.constant = totalHeight >= maxHeight ? maxHeight : totalHeight
        tableView.isScrollEnabled = true
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<Insurance>, DefaultCellModel<Insurance>,Insurance>.init(.SingleListing(items: insurances ?? [], identifier: InsuranceCell.identfier, height: 40.0, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? InsuranceCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            if /self?.hadInsurance == false {
                return
            }
            if /self?.isMultiSelectionOfInsurances {
                item?.property?.model?.isSelected = !(/item?.property?.model?.isSelected)
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self?.insurances?.forEach({$0.isSelected = false})
                self?.insurances?[indexPath.row].isSelected = true
                self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.insurances ?? []), .FullReload)
            }
        }
    }
    
    private func configureInsuranceInfos() {
        
        let totalHeight = /CGFloat(/insuranceInfos.count * 80)
        heightInsuranceInfo.constant = totalHeight
        tableViewInsuranceInfo.isScrollEnabled = true
        
        dataSourceInsuranceInfo = TableDataSource<DefaultHeaderFooterModel<InsuranceInfo>, DefaultCellModel<InsuranceInfo>, InsuranceInfo>.init(.SingleListing(items: insuranceInfos, identifier: InsuranceDetailCell.identfier, height: 80.0, leadingSwipe: nil, trailingSwipe: nil), tableViewInsuranceInfo)
        
        dataSourceInsuranceInfo?.configureCell = { (cell, item, indexPath) in
            (cell as? InsuranceDetailCell)?.item = item
            (cell as? InsuranceDetailCell)?.didTapDelete = { [weak self] in
                self?.insuranceInfos.remove(at: indexPath.row)
                self?.dataSourceInsuranceInfo?.updateAndReload(for: .SingleListing(items: self?.insuranceInfos ?? []), .FullReload)
                let totalHeight = /CGFloat(/self?.insuranceInfos.count * 80)
                self?.heightInsuranceInfo.constant = totalHeight
                self?.btnadd.isHidden = false
            }
        }
    }
    
    private func getCountryStateCityAPI(type: CountryStateCity, countryId: Int?, stateId: Int?) {
        EP_Home.getCountryStateCity(type: type, countryId: countryId, stateId: stateId).request(success: { [weak self] (responseData) in
            if stateId == nil {
                self?.statePicker?.updateItems((responseData as? CountryStateCityData)?.getStates())
            } else {
                self?.cityPicker?.updateItems((responseData as? CountryStateCityData)?.getCities())
            }
        })
    }
    
    private func validateValues() {
        if /UserPreference.shared.clientDetail?.hasAddress() {
            let isValidAddress = Validation.shared.validate(values: (.ADDRESS, /tfAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)),
                                                                    (.STATE, /tfState.text?.trimmingCharacters(in: .whitespacesAndNewlines)),
                                                                    (.CITY, /tfCity.text?.trimmingCharacters(in: .whitespacesAndNewlines)))
            
            switch isValidAddress {
            case .success:
                if /UserPreference.shared.clientDetail?.hasZipCode(for: .customer) {
                    switch Validation.shared.validate(values: (.ZIP, /tfZip.text?.trimmingCharacters(in: .whitespacesAndNewlines))) {
                    case .success:
                        break
                    case .failure(let type, let alertMessage):
                        Toast.shared.showAlert(type: type, message: alertMessage.localized)
                        return
                    }
                }
            case .failure(let type, let alertMessage):
                Toast.shared.showAlert(type: type, message: alertMessage.localized)
                return
            }
        }
        
        if /UserPreference.shared.clientDetail?.hasInsurance() {
            if /hadInsurance {
                if /insurances?.filter({ /$0.isSelected }).count == 0 {
                    Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.MINIMUM_INSURANCE_SELECT.localized)
                    return
                }
            }
        }
        
        if termsSelected.terms1 && termsSelected.terms2 && termsSelected.terms3 {
            updateAddressLicencesAPI()
        } else {
            Toast.shared.showAlert(type: .validationFailure, message: VCLiteral.TERMS_VALIDATION.localized)
        }
    }
    
    private func updateAddressLicencesAPI() {
        btnSubmit.playAnimation()

        let selectedInsuranceIDs = insurances?.filter({/$0.isSelected}).map({ String(/$0.id) })
        
        var customFields: String?
        var fields = [CustomField]()
        
        if let zipCode = UserPreference.shared.clientDetail?.getCustomField(for: .ZipCode, user: .customer) {
            zipCode.field_value = tfZip.text
            fields.append(zipCode)
            customFields = JSONHelper<[CustomField]>().toJSONString(model: fields)
        }
        
        let insurancesInfoBackend = JSONHelper<[InsuranceInfo]>().toDictionary(model: insuranceInfos)
        
        EP_Login.updateInsuranceAndAddress(name: /UserPreference.shared.data?.name, address: tfAddress.text, country: String(/UserPreference.shared.clientDetail?.country_id), state: String(/currentState?.id), city: String(/currentCity?.id), insurance_enable: hadInsurance ? "1" : "0", insurances: selectedInsuranceIDs?.joined(separator: ","), custom_fields: customFields, insurance_info: hadInsurance ? insurancesInfoBackend : nil).request(success: { [weak self] (responseData) in
            
            self?.btnSubmit.stop()
            
            /self?.isUpdating ? self?.popTo(toControllerType: ProfileVC.self) : UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
            
        }) { [weak self] (error) in
            self?.btnSubmit.stop()
        }
    }
}
