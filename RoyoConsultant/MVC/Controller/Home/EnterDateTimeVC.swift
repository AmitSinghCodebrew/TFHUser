//
//  EnterDateTimeVC.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 05/08/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit
#if NurseLynx
import GoogleMaps
class EnterDateTimeVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblAddressValue: UILabel!
    
    @IBOutlet weak var btnApply: SKLottieButton!
    @IBOutlet weak var viewTickUnTick: UIView!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var tickBackView: UIView!
    @IBOutlet weak var lblTerms: SKLabel!
    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var tfEndDate: UITextField!
    @IBOutlet weak var tfStartTime: UITextField!
    @IBOutlet weak var tfEndTime: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwAddress: UIView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<TierOption>, DefaultCellModel<TierOption>, TierOption>?
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    private var dataSourceCollection: CollectionDataSource?
    
    private var items = [TierHeaderProvider]()
    private var selectedItems: [TierOption]?
    private var selectedTier: Tier?
    var vendors: [Vendor]?
    
    var service: Service?
    var category: Category?
    
    private var address: Address?
    private var isTermsAgreed = false
    private var startDate: Date?
    private var endDate: Date?
    private var endTime: Date?
    private var startTime: Date?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizedTextSetup()
        tableViewInit()
        
        //ARTASK
//        if !(service?.main_service_type == .clinic_visit || service?.main_service_type == .home_visit) {
//            mapView.isHidden = true
//            vwAddress.isHidden = true
//        } else {
            
            let currentLocation = LocationManager.shared.locationData
            generateAddress(latLng: address ?? Address(currentLocation.latitude, currentLocation.longitude, nil))

            moveToCurrentLcoation()
//        }
        getVendorList()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
            
        case 2: //Add Address
            
            let destVC = Storyboard<AddAddressVC>.Home.instantiateVC()
            destVC.address = address
            destVC.didSelected = { [weak self] (address) in
                self?.lblAddressValue.text = /address?.name
                self?.address = address
                
                self?.getVendorList()
            }
            pushVC(destVC)
        case 3: //Terms Tick UnTick
            isTermsAgreed = !(isTermsAgreed)
            btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
            btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        case 4: // Confirm
            
            apiCreateRequest()
            break
        default:
            break
        }
    }
    
    private func apiCreateRequest() {
        
        if tfStartDate.text == "" || tfEndDate.text == "" || tfStartTime.text == "" || tfEndTime.text == ""{
            Toast.shared.showAlert(type: .validationFailure, message: /VCLiteral.CHOOSE_DATE_TIME.localized)
            btnApply.vibrate()

            return
        }
        if startDate?.compare(endDate ?? Date()) == ComparisonResult.orderedDescending {
            Toast.shared.showAlert(type: .notification, message: VCLiteral.START_DATE_GREATER.localized)
            btnApply.vibrate()

            return
        }
        if startDate?.compare(endDate ?? Date()) == ComparisonResult.orderedSame {

            let time1 = 60*Calendar.current.component(.hour, from: startTime!) + Calendar.current.component(.minute, from: startTime!)
            let time2 =  60*Calendar.current.component(.hour, from: endTime!) + Calendar.current.component(.minute, from: endTime!)
            
            if time1 > time2 {
                Toast.shared.showAlert(type: .notification, message: VCLiteral.TIME_GREATER.localized)
                btnApply.vibrate()

                return
            }
        }
        if !isTermsAgreed {
            btnApply.vibrate()
            return
        }
        
        btnApply.playAnimation()
        let scheduleType: ScheduleType = .schedule
        
        let startDate = self.startDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true)
        let startTime = Date.init(fromString: /tfStartTime.text, format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local, isForAPI: true)
        
        let endDate = self.endDate?.toString(DateFormat.custom("yyyy-MM-dd"), timeZone: .local, isForAPI: true)
        let endTime = Date.init(fromString: /tfEndTime.text, format: DateFormat.custom("hh:mm a")).toString(DateFormat.custom("HH:mm"), timeZone: .local, isForAPI: true)
        
        selectedTier?.tier_options = selectedItems
        
        EP_Others.confirmRequest(consultant_id: nil, date: startDate, time: startTime, service_id: String(/service?.service_id), schedule_type: scheduleType, coupon_code: nil, request_id: nil, latitude: address?.latitude, longitude: address?.longitude, service_address: address?.name, secondOpinion: nil, title: nil, images: nil, tier_id: selectedTier?.id, tier_options: selectedTier?.getOptionsForBackend(), end_date: endDate, end_time: endTime, category_id: "\(/category?.id)").request(success: { [weak self] (responseData) in
            
            self?.btnApply.stop()
            let response = responseData as? ConfirmBookingData
            
            let destVC = Storyboard<ConfirmRequestPopVC>.Other.instantiateVC()
            destVC.confirmData = response
            destVC.service = self?.service
            destVC.category = self?.category
            destVC.startDate = self?.startDate
            destVC.endDate = self?.endDate
            destVC.time = self?.tfStartTime.text
            destVC.endTime = self?.tfEndTime.text
            destVC.address = self?.address
            destVC.selectedTier = self?.selectedTier
            
            
            destVC.backHandler = {
                self?.dismissVC()
                
                self?.alertBoxOK(title:  Configuration.appName() , message: "Sorry no professionals are in your area please call us for assistance (301) 241-7374.", tapped: {
                print("Dismiss")
                })
                
               // self?.alertWithDesc(desc: "Sorry no professionals are in your area please call us for assistance (301) 241-7374.")
            }
            
            
            destVC.didReceiveRequestId = { (requestId) in
                let destVC = Storyboard<ApptDetailVC>.Home.instantiateVC()
                destVC.requestID = Int(/requestId)
                self?.pushVC(destVC)
            }
            self?.presentVC(destVC)

        }) { [weak self] (error) in
            self?.btnApply.stop()
        }
    }
    private func showInvalidBalanceAlert(message: String?, minAmount: Double?) {
     
        let minimumAmount = /minAmount?.getFormattedPrice()
        let defaultMessage = String(format: VCLiteral.WALLET_ALERT_MESSAGE.localized, minimumAmount)
        
        alertBox(title: VCLiteral.WALLET_ALERT.localized, message: message ?? defaultMessage, btn1: VCLiteral.ADD_MONEY.localized, btn2: VCLiteral.CANCEL.localized, tapped1: {
            let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
            UIApplication.topVC()?.pushVC(destVC)
        }, tapped2: nil)
    }
   
}
extension EnterDateTimeVC {
    
    private func localizedTextSetup() {
        
        tableHeight.constant = 0

        lblTitle.text = VCLiteral.CHOOSE_DATE_TIME.localized
        lblAddress.text = VCLiteral.ADDRESS.localized
        lblAddressValue.text = nil
        btnApply.setTitle(VCLiteral.DONE.localized, for: .normal)
        
        let termsText = String.init(format: VCLiteral.TERMS_CONFIRM_BOOKING.localized, VCLiteral.SALES_CONTRACT.localized)
        
        btnTick.backgroundColor = isTermsAgreed ? ColorAsset.appTint.color : .clear
        btnTick.setImage(isTermsAgreed ? #imageLiteral(resourceName: "ic_tick") : nil, for: .normal)
        
        lblTerms.setAttributedText(original: (termsText, Fonts.CamptonBook.ofSize(12), ColorAsset.txtLightGrey.color), toReplace: (VCLiteral.SALES_CONTRACT.localized, Fonts.CamptonMedium.ofSize(12), ColorAsset.txtTheme.color))
        lblTerms.textAlignment = .left
        lblTerms.setLinkedTextWithHandler(text: termsText, link: VCLiteral.SALES_CONTRACT.localized) { [weak self] in
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = ("\(/UserPreference.shared.clientDetail?.domain_url)/\(APIConstants.salesAgreement)", VCLiteral.SALES_CONTRACT.localized)
            self?.pushVC(destVC)
        }
        
        tfStartDate.inputView = SKDatePicker.init(frame: .zero, maxDate: nil, minDate: Date(), configureDate: { [weak self] (date) in
            self?.startDate = date
            self?.tfStartDate.text = date.toString(DateFormat.custom("MMM d, yyyy"), isForAPI: false)
        })
        
        tfEndDate.inputView = SKDatePicker.init(frame: .zero, maxDate: nil, minDate: startDate ?? Date(), configureDate: { [weak self] (date) in
            self?.endDate = date
            self?.tfEndDate.text = date.toString(DateFormat.custom("MMM d, yyyy"), isForAPI: false)
        })
        
        tfStartTime.inputView = SKDatePicker.init(frame: .zero, mode: .time, maxDate: nil, minDate: nil, interval: 30, configureDate: { [weak self] (date) in
            self?.startTime = date
            self?.tfStartTime.text = date.toString(DateFormat.custom("hh:mm a"), isForAPI: false)
        })
        
        tfEndTime.inputView = SKDatePicker.init(frame: .zero, mode: .time, maxDate: nil, minDate: nil, interval: 30, configureDate: { [weak self] (date) in
            self?.endTime = date
            self?.tfEndTime.text = date.toString(DateFormat.custom("hh:mm a"), isForAPI: false)
        })
    }
}
extension EnterDateTimeVC {
    
    private func getTiers() {

        EP_Home.tiers.request { [weak self] (responseData) in
            self?.items = TierHeaderProvider.getSections(tiers: (responseData as? TiersData)?.tiers)
            
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.collectionViewInit()
        } error: { (error) in
            
        }
    }
    
    private func tableViewInit() {

        dataSource = TableDataSource<DefaultHeaderFooterModel<TierOption>, DefaultCellModel<TierOption>, TierOption>.init(.SingleListing(items: selectedItems ?? [], identifier: CarePlanCellNew.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        //        dataSource?.configureHeaderFooter = { (section, item, view) in
        //            (view as? CarePlanHeaderView)?.item = item
        //            (view as? CarePlanHeaderView)?.didTap = { [weak self] in
        //                self?.items.forEach({ $0.items = [] })
        //                item.items = TierCellProvider.getCells(options: item.headerProperty?.model?.tier_options)
        //                self?.items[section] = item
        //                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
        //            }
        //        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CarePlanCellNew)?.item = item
            (cell as? CarePlanCellNew)?.reloadCell = { [weak self] (tierOption) in
                self?.selectedItems?[indexPath.row] = tierOption!
                self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.selectedItems ?? []), .FullReload)
            }
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.getTiers()
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func collectionViewInit() {
        
        let widthOfBtn = (UIScreen.main.bounds.width - 64.0) / 3
        let heightOfBtn = CGFloat(40)
        
        dataSourceCollection = CollectionDataSource.init(items , TierCollectionCell.identfier, collectionVIew, CGSize.init(width: widthOfBtn, height: heightOfBtn), UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8), 8, 8, .horizontal)
        
        dataSourceCollection?.configureCell = { (cell, item, indexPath) in
            (cell as? TierCollectionCell)?.item = item
        }
        
        dataSourceCollection?.didSelectItem = { [weak self] (indexPath, item) in
            self?.items.forEach({ $0.items = [] })
            self?.items.forEach({ $0.items?.forEach({ $0.property?.model?.type = .None }) })
            
            self?.items.forEach( {$0.headerProperty?.model?.isSelected = false } )
            self?.items[indexPath.row].headerProperty?.model?.isSelected = true
            self?.collectionVIew.reloadData()
            
            self?.selectedTier = self?.items[indexPath.row].headerProperty?.model
            self?.selectedItems = self?.items[indexPath.row].headerProperty?.model?.tier_options ?? []
            self?.selectedItems?.forEach({ $0.type = .None })
            
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.selectedItems ?? []), .FullReload)
            
            self?.tableHeight.constant = 0
            UIView.animate(withDuration: 1.0) {
                self?.tableHeight.constant = /self?.tableView.contentSize.height
            }
        }
    }
}
extension EnterDateTimeVC {
    private func moveToCurrentLcoation() {
        let camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared.locationData.latitude,
                                              longitude: LocationManager.shared.locationData.longitude,
                                              zoom: 10)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        
    }
    //MARK:- Get Address String from latitude longitude
    private func generateAddress(latLng: Address?) {
        let location = CLLocation.init(latitude: /latLng?.latitude?.rounded(toPlaces: 4), longitude: /latLng?.longitude?.rounded(toPlaces: 4))
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (clPlacemark, error) in
            guard let placeMark = clPlacemark?.first else {
                print("No placemark from Apple: \(String(describing: error))")
                return
            }
            var address: String = ""
            
            // Location name
            if let locationName = placeMark.name {
                address += locationName
            }
            
            // Street address
            if let street = placeMark.thoroughfare {
                if !address.contains(street) {
                    address += ", " + street
                }
            }
            
            // City
            if let city = placeMark.locality {
                if !address.contains(city) {
                    address += ", " + city
                }
            }
            
            // Zip code
            if let zip = placeMark.postalCode {
                if !address.contains(zip) {
                    address += ", " + zip
                }
            }
            
            // SubAdministrativeArea
            if let submins = placeMark.subAdministrativeArea {
                if !address.contains(submins) {
                    address += ", " + submins
                }
            }
            
            // Country
            if let country = placeMark.country {
                if !address.contains(country) {
                    address += " - " + country
                }
            }
            self?.lblAddressValue.text = /address
            self?.address = latLng
            self?.address?.name = /address
        }
    }
}
extension EnterDateTimeVC {
    
    private func getVendorList(isRefreshing: Bool? = false) {
        
        let currentLocation = LocationManager.shared.locationData
        
        EP_Others.vendorListV2(categoryId: category?.id, service_id: service?.service_id, search: nil, serviceType: service?.main_service_type, lat: "\(address?.latitude ?? /currentLocation.latitude)", long: "\(address?.longitude ?? /currentLocation.longitude)", address_id: nil).request(success: { [weak self] (responseData) in
            
            let response = responseData as? VendorData
            self?.vendors = response?.vendors
            self?.showAnnotations()
            
        }) {  (_) in
        }
        
    }
    
    private func showAnnotations() {
        
        for vendor in vendors ?? [] {
            
            let position = CLLocationCoordinate2D.init(latitude: /Double(/vendor.vendor_data?.profile?.lat), longitude: /Double(/vendor.vendor_data?.profile?.long))
            let locationmarker = GMSMarker(position: position)
            locationmarker.title = /vendor.vendor_data?.name
            locationmarker.map = mapView
            locationmarker.icon = UIImage(named: "ic_end_point")
            
        }
    }
}
#endif
