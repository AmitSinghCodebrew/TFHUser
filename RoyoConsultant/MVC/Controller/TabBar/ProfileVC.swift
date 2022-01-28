//
//  SideMenuVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

class ProfileVC: BaseVC {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblVersionNo: UILabel!
    @IBOutlet weak var lblVersionInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var btnWallet: RTLSupportedButton!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<ProfileItem>, DefaultCellModel<ProfileItem>, ProfileItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        imgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(editProfile)))
        #if HomeDoctorKhalid
        lblBalance.isHidden = false
        lblBalance.text = ""
        #else
        lblBalance.isHidden = true
        #endif
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateProfileData()
        #if HomeDoctorKhalid
        getWalletBalanceAPI()
        #endif
    }
    
    @IBAction func btnWalletAction(_ sender: UIButton) {
        pushVC(Storyboard<WalletVC>.Home.instantiateVC())
    }
}

//MARK:- VCFuncs
extension ProfileVC {
    private func getWalletBalanceAPI() {
        if /UserPreference.shared.data?.token == "" {
            return
        }
        EP_Home.wallet.request(success: { [weak self] (responseData) in
            let walletBalance = (responseData as? WalletBalance)?.balance
            self?.lblBalance.text = walletBalance?.getFormattedPrice()
        }) { (error) in
            
        }
    }
    
    public func updateProfileData() {
        tableView.tableHeaderView = headerView
        lblName.text = "\(/UserPreference.shared.data?.profile?.title) \(/UserPreference.shared.data?.name)".trimmingCharacters(in: .whitespaces)
        var age = VCLiteral.NA.localized
        if /UserPreference.shared.data?.profile?.dob != "" {
            let tempAge = Date().year() - /Date.init(fromString: /UserPreference.shared.data?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).year()
            age = (tempAge == 0 ? VCLiteral.NA.localized : "\(tempAge)")
        }
        lblAge.text = String.init(format: VCLiteral.AGE.localized, age)
        imgView.setImageNuke(/UserPreference.shared.data?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.PROFILE.localized
        lblVersionNo.text = String.init(format: VCLiteral.VERSION.localized, Bundle.main.versionNumber)
        lblVersionInfo.text = VCLiteral.VERSION_INFO.localized
        tableView.contentInset.top = 16.0
        
        #if HealthCarePrashant
        viewLocation.isHidden = false
        lblLocation.text = /LocationManager.shared.address?.name
        lblAge.isHidden = true
        #else
        viewLocation.isHidden = true
        #endif
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<ProfileItem>, DefaultCellModel<ProfileItem>, ProfileItem>.init(.SingleListing(items: ProfileItem.getItems(pages: UserPreference.shared.pages), identifier: SideMenuCell.identfier, height: 56.0, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? SideMenuCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            switch item?.property?.model?.title ?? .HOME {
            case .HISTORY:
                self?.pushVC(Storyboard<HistoryVC>.Home.instantiateVC())
            case .NOTIFICATIONS:
                self?.pushVC(Storyboard<NotificationsVC>.Home.instantiateVC())
            case .BANK_DETAILS:
                self?.pushVC(Storyboard<BankDetailVC>.Home.instantiateVC())
            case .INVITE_PEOPLE:
                self?.shareApp(self?.tableView.cellForRow(at: indexPath))
            case .PACAKAGES:
                self?.pushVC(Storyboard<PackagesVC>.Home.instantiateVC())
            case .SECOND_OPINION:
                self?.pushVC(Storyboard<SecondOpinionListingVC>.Home.instantiateVC())
            case .ACCOUNT_SETTINGS:
                self?.pushVC(Storyboard<ProfileDetailVC>.Home.instantiateVC())
            case .CHANGE_PASSWORD:
                let destVC = Storyboard<ChangePSWVC>.LoginSignUp.instantiateVC()
                destVC.didSuccess = { [weak self] in
                    let successVC = Storyboard<SuccessPopUpVC>.PopUp.instantiateVC()
                    successVC.modalPresentationStyle = .overFullScreen
                    successVC.message = VCLiteral.PASSWORD_SUCCESS_MESSAGE.localized
                    self?.present(successVC, animated: true, completion: nil)
                }
                self?.pushVC(destVC)
            case .CHANGE_LANGUAGE:
                self?.openLanguageActionSheet(languages: [.English, .Arabic])
            case .LOGOUT:
                self?.logoutAlert()
            case .CONTACT_US:
                break
            //                self?.pushVC(Storyboard<ContactUsVC>.Home.instantiateVC())
            case .SUPPORT:
                let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                destVC.linkTitle = (UserPreference.shared.clientDetail?.support_url, VCLiteral.SUPPORT.localized)
                self?.pushVC(destVC)
            #if CloudDoc
            case .IDCARD:
                self?.playLineAnimation()
                EP_Home.subscriptions(after: nil).request { [weak self] responseData in
                    self?.stopLineAnimation()
                    let response = (responseData as? PackagesData)
                    if /response?.active_plan {
                        let destVC = Storyboard<IDCardPopUpVC>.PopUp.instantiateVC()
                        self?.presentPopUp(destVC)
                    } else {
                        self?.alertWithDesc(desc: VCLiteral.ID_CARD_ALERT.localized)
                    }
                } error: { [weak self] error in
                    self?.stopLineAnimation()
                }
            #endif
            default:
                let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                destVC.linkTitle = ("\(/UserPreference.shared.clientDetail?.domain_url)/\(/item?.property?.model?.page?.slug)", /item?.property?.model?.page?.title)
                self?.pushVC(destVC)
            }
        }
    }
    
    @objc private func editProfile() {
        pushVC(Storyboard<ProfileDetailVC>.Home.instantiateVC())
    }
    
    private func shareApp(_ source: UIView?) {
        let appLink = "\(Configuration.getValue(for: .PROJECT_BASE_PATH))\(DynamicLinkPage.Invite.rawValue)"
        
        guard let shareLink = DynamicLinkComponents.init(link: URL.init(string: appLink)!, domainURIPrefix: "https://\(Configuration.getValue(for: .PROJECT_FIREBASE_PAGE_LINK))") else {
            return
        }
        
        shareLink.iOSParameters = DynamicLinkIOSParameters.init(bundleID: /Bundle.main.bundleIdentifier)
        shareLink.iOSParameters?.appStoreID = Configuration.getValue(for: .PROJECT_APPLE_APP_ID)
        shareLink.androidParameters = DynamicLinkAndroidParameters.init(packageName: Configuration.getValue(for: .PROJECT_ANDROID_PACKAGE_NAME))
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = Bundle.main.infoDictionary?["CFBundleName"] as? String
        shareLink.socialMetaTagParameters?.descriptionText = VCLiteral.APP_DESC.localized
        shareLink.socialMetaTagParameters?.imageURL = URL.init(string: Configuration.getValue(for: .PROJECT_IMAGE_UPLOAD) + /UserPreference.shared.clientDetail?.applogo)
        
        shareLink.shorten { [weak self] (url, warnings, error) in
            var shareItems = [/url?.absoluteString]
            if /UserPreference.shared.clientDetail?.invite_enabled {
                shareItems.append(String.init(format: VCLiteral.USE_REFER_CODE.localized, /UserPreference.shared.data?.reference_code))
            }
            self?.share(items: shareItems, sourceView: source)
        }
    }
    
    private func logoutAlert() {
        alertBoxOKCancel(title: VCLiteral.LOGOUT.localized, message: VCLiteral.LOGOUT_ALERT_MESSAGE.localized, tapped: { [weak self] in
            self?.logoutAPI()
        }, cancelTapped: nil)
    }
    
    private func logoutAPI() {
        playLineAnimation()
        EP_Home.logout.request(success: { [weak self] (_) in
            self?.stopLineAnimation()
            UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
            SocketIOManager.shared.disconnect()
        }) { [weak self] (_) in
            self?.stopLineAnimation()
        }
    }
    
    private func openLanguageActionSheet(languages: [AppleLanguage]) {
        actionSheet(for: languages.map({$0.title.localized}), title: "", message: VCLiteral.CHOOSE_LANGUAGE.localized) { (tappedLanguage) in
            switch tappedLanguage {
            case VCLiteral.LANGUAGE_ENGLISH.localized:
                L102Language.setAppleLanguage(to: .English)
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                (UIApplication.shared.delegate as! AppDelegate).setRoot(for: Storyboard<NavgationTabVC>.TabBar.instantiateVC())
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.apiToFetchPage()
            
            case VCLiteral.LANGUAGE_ARABIC.localized:
                L102Language.setAppleLanguage(to: .Arabic)
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                (UIApplication.shared.delegate as! AppDelegate).setRoot(for: Storyboard<NavgationTabVC>.TabBar.instantiateVC())
              
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.apiToFetchPage()
            default:
                break
            }
        }
    }
}
