//
//  VendorDetailVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import MXParallaxHeader
import FirebaseDynamicLinks

class VendorDetailVC: BaseVC {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRatingReviews: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(VendorDetailHeaderView.identfier)
        }
    }
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var viewExp: UIView!
    @IBOutlet weak var btnConsult: SKButton!
    
    @IBOutlet weak var lblExtra1InfoTitle: UILabel!
    @IBOutlet weak var lblExtra2InfoTitle: UILabel!
    @IBOutlet weak var lblExtra3InfoTitle: UILabel!
    @IBOutlet weak var lblExtra1Value: UILabel!
    @IBOutlet weak var lblExtra2Value: UILabel!
    @IBOutlet weak var lblExtra3Value: UILabel!
    @IBOutlet weak var viewConsult: UIView!
    
    public var vendor: User?
    private var dataSource: TableDataSource<VD_HeaderFooter_Provider, VD_Cell_Provider, VD_Modal>?
    private var items: [VD_HeaderFooter_Provider]?
    private var after: String?
    public var isSecondOpinion = false
    public var serviceType: ServiceType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getVendorDetailAPI()
        
        if AppSettings.isLocationEnabled {
            LocationManager.shared.startTrackingUser()
        }
    }
    
    @IBAction func btnConsultAction(_ sender: SKLottieButton) {
        let service = vendor?.services?.first(where: {
            $0.main_service_type == self.serviceType
        })
        consult(for: service)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Share
            let url = "\(Configuration.getValue(for: .PROJECT_BASE_PATH))\(DynamicLinkPage.userProfile.rawValue)?id=\("\(/vendor?.id)")"
            
            guard let link = URL.init(string: url) else { return }
            
            guard let shareLink = DynamicLinkComponents.init(link: link, domainURIPrefix: "https://\(Configuration.getValue(for: .PROJECT_FIREBASE_PAGE_LINK))") else {
                return
            }
            shareLink.iOSParameters = DynamicLinkIOSParameters.init(bundleID: /Bundle.main.bundleIdentifier)
            shareLink.iOSParameters?.appStoreID = Configuration.getValue(for: .PROJECT_APPLE_APP_ID)
            shareLink.iOSParameters?.minimumAppVersion = Bundle.main.versionNumber
            shareLink.androidParameters = DynamicLinkAndroidParameters.init(packageName: Configuration.getValue(for: .PROJECT_ANDROID_PACKAGE_NAME))
            shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            shareLink.socialMetaTagParameters?.title = "\(/vendor?.categoryData?.name) | \(/vendor?.name)"
            shareLink.socialMetaTagParameters?.descriptionText = /vendor?.profile?.bio
            
            if /vendor?.profile_image != "" {
                shareLink.socialMetaTagParameters?.imageURL = URL.init(string: Configuration.getValue(for: .PROJECT_IMAGE_UPLOAD) + /vendor?.profile_image)
            } else {
                shareLink.socialMetaTagParameters?.imageURL = URL.init(string: Configuration.getValue(for: .PROJECT_IMAGE_UPLOAD) + /UserPreference.shared.clientDetail?.applogo)
            }
            
            shareLink.shorten { [weak self] (url, warnings, error) in
                self?.share(items: [/url?.absoluteString], sourceView: sender)
            }
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension VendorDetailVC {
    private func initialSetup() {
        lblName.text = "\(/vendor?.profile?.title) \(/vendor?.name)".trimmingCharacters(in: .whitespaces)
        lblTitle.text = /vendor?.name
        imgView.setImageNuke(/vendor?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        let experience = "\(Date().year() - /Date.init(fromString: /vendor?.profile?.working_since, format: DateFormat.custom("yyyy-MM-dd")).year())".experience
        if (Date().year() - /Date.init(fromString: /vendor?.profile?.working_since, format: DateFormat.custom("yyyy-MM-dd")).year()) == 0 {
            viewExp.isHidden = true
        } else {
            viewExp.isHidden = false
        }
        var desc = [/vendor?.qualification, /vendor?.speciality, /vendor?.categoryData?.name]
        desc.removeAll(where: {/$0 == ""})
        lblDesc.text = "    \(desc.joined(separator: " · "))    "
        lblAddress.text =  vendor?.profile?.address ?? VCLiteral.NA.localized
        lblRatingReviews.text = "\(/vendor?.totalRating) · \(/vendor?.reviewCount) \(/vendor?.reviewCount == 1 ? VCLiteral.REVIEW.localized : VCLiteral.REVIEWS.localized)"
        
        #if HealthCarePrashant
        lblExtra1InfoTitle.text = VCLiteral.CONSULTANTS.localized
        lblExtra1Value.text = "\(/vendor?.consultationCount)"
        #else
        lblExtra1InfoTitle.text = VCLiteral.PATIENTS.localized
        lblExtra1Value.text = "\(/vendor?.patientCount)"
        #endif
        
        lblExtra2InfoTitle.text = VCLiteral.EXPERIECE.localized
        lblExtra2Value.text = experience
        lblExtra3InfoTitle.text = VCLiteral.REVIEWS.localized
        lblExtra3Value.text = "\(/vendor?.reviewCount)"
        
        let service = vendor?.services?.first(where: {
            $0.main_service_type == self.serviceType
        })
        
        btnConsult.titleLabel?.lineBreakMode = .byWordWrapping
        btnConsult.titleLabel?.textAlignment = .center
        
        switch serviceType {
        case .home_visit, .clinic_visit:
            viewConsult.isHidden = /vendor?.services?.count == 0
        default:
            viewConsult.isHidden = true
        }
        
        btnConsult.setTitle(String.init(format: VCLiteral.CONSULT_FOR.localized, arguments: ["\(/service?.service_name)\n", "\(/service?.price?.getFormattedPrice()) \(/service?.unit_price?.getServicePerUnit())"]), for: .normal)
        
        tableView.parallaxHeader.view = headerView
        tableView.parallaxHeader.mode = .bottom
        tableView.parallaxHeader.height = 216
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.delegate = self
        
        tableViewInit()
        
        navView.alpha = 0.0
    }
    
    private func tableViewInit() {
        items = VD_HeaderFooter_Provider.getItems(vendor, serviceType: serviceType)
        
        dataSource = TableDataSource<VD_HeaderFooter_Provider, VD_Cell_Provider, VD_Modal>.init(.MultipleSection(items: items ?? []), tableView)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? VendorDetailHeaderView)?.item = item
            (view as? VendorDetailHeaderView)?.didTapViewALL = { [weak self] in
                let destVC = Storyboard<ClassesVC>.Home.instantiateVC()
                destVC.vendor = self?.vendor
                self?.pushVC(destVC)
            }
        }
        
        dataSource?.configureCell = { [weak self] (cell, item, indexPath) in
            (cell as? VendorExtraInfoCell)?.item = item
            (cell as? VendorDetailCollectionTVCell)?.consultFor = { (service) in
                self?.consult(for: service)
            }
            (cell as? VendorDetailCollectionTVCell)?.item = item
            (cell as? AboutCell)?.item = item
            (cell as? AboutCell)?.reloadCell = {
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            (cell as? ReviewCell)?.item = item
            (cell as? ReviewCell)?.reloadCell = {
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            (cell as? ClassCell)?.item2 = item
            (cell as? ClassCell)?.didReloadCellWithObj = { [weak self] (classObj) in
                self?.items?[indexPath.section].items?[indexPath.row].property?.model?.classObj = classObj!
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getReviewsAPI()
            }
        }
    }
    
    private func getVendorDetailAPI() {
        EP_Home.vendorDetail(id: String(/vendor?.id)).request(success: { [weak self] (responseData) in
            self?.vendor = responseData as? User
            self?.items = VD_HeaderFooter_Provider.getItems(self?.vendor, serviceType: self?.serviceType)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            self?.playLineAnimation()
            self?.initialSetup()
            #if HealthCarePrashant
            self?.getReviewsAPI()
            #else
            /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: false) ? self?.getClassesAPI() : self?.getReviewsAPI()
            #endif
        }) { (error) in
            
        }
    }
    
    private func getClassesAPI() {
        EP_Home.classes(type: .USER_SIDE, categoryId: nil, after: nil, vendorID: vendor?.id).request(success: { [weak self] (responseData) in
            let classes = (responseData as? ClassesData)?.classes
            if let section = VD_HeaderFooter_Provider.getClasses(classes: classes) {
                self?.items?.append(section)
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .InsertSection(indexSet: IndexSet(integer: /self?.items?.count - 1), animation: .automatic))
            }
            self?.getReviewsAPI()
        }) { [weak self] (_) in
            self?.getReviewsAPI()
        }
    }
    
    private func getReviewsAPI() {
        EP_Home.getReviews(vendorId: String(/vendor?.id), after: after).request(success: { [weak self] (responseData) in
            let resposne = responseData as? ReviewsData
            self?.after = resposne?.after
            if /resposne?.review_list?.count > 0 {
                let reviewSection = VD_HeaderFooter_Provider.getReviewsSection(self?.vendor, reviews: resposne?.review_list)
                if /self?.items?.last?.items?.first?.property?.identifier == ReviewCell.identfier { //Reviews Exist
                    let reviews = (self?.items?.last?.items ?? []) + (reviewSection.items ?? [])
                    self?.items?.last?.items = reviews
                    self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .ReloadSectionAt(indexSet: IndexSet(integer: /self?.items?.count - 1), animation: .automatic))
                } else {
                    self?.items?.append(reviewSection)
                    self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .InsertSection(indexSet: IndexSet(integer: /self?.items?.count - 1), animation: .bottom))
                }
            }
            self?.dataSource?.stopInfiniteLoading(/resposne?.review_list?.count == 0 ? .NoContentAnyMore : .FinishLoading)
            self?.stopLineAnimation()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
    
    private func consult(for service: Service?) {
        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) == false {
            return
        }
        
        if service?.need_availability == .TRUE {
            let destVC = Storyboard<CreateSchedulePopUpVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.scheduleTypeTapped = { (scheduleType) in
                switch scheduleType {
                case .instant:
                    //                        if /packages?.count == 0 {
                    let destVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                    destVC.vendor = self.vendor
                    destVC.service = service
                    destVC.isSecondOpinion = self.isSecondOpinion
                    if /self.isSecondOpinion {
                        let secondOpinionVC = Storyboard<SecondOpinionStepVC>.Home.instantiateVC()
                        secondOpinionVC.didTaskCompleted = { (images, text) in
                            destVC.secondOpinionData = (images, text)
                            self.pushVC(destVC)
                        }
                        self.pushVC(secondOpinionVC)
                    } else {
                        self.pushVC(destVC)
                    }
                //                        } else {
                //                            let packagesVC = Storyboard<PurchasedSubsVC>.Home.instantiateVC()
                //                            packagesVC.items = packages
                //                            packagesVC.vendor = self.item?.property?.model?.vendor
                //                            packagesVC.service = item as? Service
                //                            packagesVC.scheduleType = .instant
                //                            packagesVC.isSecondOpinion = self.isSecondOpinion
                //                            .pushVC(packagesVC)
                //                        }
                case .schedule:
                    //                        if /packages?.count == 0 {
                    let destVC = Storyboard<ChooseDateTimeVC>.Home.instantiateVC()
                    destVC.vendor = self.vendor
                    destVC.service = service
                    destVC.didSelecteDateTime = { (selectedDateTimeData) in
                        let confirmVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
                        confirmVC.vendor = self.vendor
                        confirmVC.service = service
                        confirmVC.selectedDateTime = selectedDateTimeData
                        confirmVC.isSecondOpinion = self.isSecondOpinion
                        if /self.isSecondOpinion {
                            let secondOpinionVC = Storyboard<SecondOpinionStepVC>.Home.instantiateVC()
                            secondOpinionVC.didTaskCompleted = { (images, text) in
                                confirmVC.secondOpinionData = (images, text)
                                self.pushVC(confirmVC)
                            }
                            self.pushVC(secondOpinionVC)
                        } else {
                            self.pushVC(confirmVC)
                        }
                    }
                    self.pushVC(destVC)
                //                        } else {
                //                            let packagesVC = Storyboard<PurchasedSubsVC>.Home.instantiateVC()
                //                            packagesVC.items = packages
                //                            packagesVC.vendor = self.item?.property?.model?.vendor
                //                            packagesVC.service = item as? Service
                //                            packagesVC.isSecondOpinion = self.isSecondOpinion
                //                            packagesVC.scheduleType = .schedule
                //                            .pushVC(packagesVC)
                //                        }
                }
            }
            presentVC(destVC)
        } else {
            let destVC = Storyboard<ConfirmBookingVC>.Home.instantiateVC()
            destVC.vendor = self.vendor
            destVC.service = service
            destVC.isSecondOpinion = self.isSecondOpinion
            
            if /self.isSecondOpinion {
                let secondOpinionVC = Storyboard<SecondOpinionStepVC>.Home.instantiateVC()
                secondOpinionVC.didTaskCompleted = { (images, text) in
                    destVC.secondOpinionData = (images, text)
                    self.pushVC(destVC)
                }
                pushVC(secondOpinionVC)
            } else {
                pushVC(destVC)
                
            }
        }
    }
}

//MARK:- MXParralaxHeaderDelegate
extension VendorDetailVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        switch parallaxHeader.progress {
        case CGFloat(0.0)...CGFloat(1.0):
            headerView.alpha = parallaxHeader.progress
            navView.alpha = 1.0 - parallaxHeader.progress
        default:
            break
        }
    }
}
