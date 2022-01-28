//
//  AppDelegate.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKLoginKit
import GoogleSignIn
import JitsiMeetSDK
import PushKit
import FirebaseDynamicLinks
import Firebase

#if Heal || HomeDoctorKhalid || NurseLynx
import GoogleMaps
#endif
//test.codebrewlab@gmail.com
//royoconsult2020

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    #if Heal
    var checkOutProvider: OPPCheckoutProvider?
    #endif
    internal var pipViewCoordinator: PiPViewCoordinator?
    internal var jitsiMeetView: JitsiMeetView?
    internal var onGoingCallRequestId: String?
    internal let voipRegistry = PKPushRegistry.init(queue: .main)
    internal var providerDelegate: ProviderDelegate?
    internal var callId: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(1)
        
        L102Localizer.DoTheMagic()
        
        print(L102Language.currentAppleLanguage()?.locale)
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions) //FBSDK Setup
        
        if #available(iOS 13.0, *) {
            //Code written in SceneDelegate
        } else {
            setRootVC()
        }
        
        #if Heal || HomeDoctorKhalid || NurseLynx
        GMSServices.provideAPIKey(/Configuration.getValue(for: .PROJECT_GOOGLE_PLACES_KEY))
        #endif
        
        IQ_KeyboaarManagerSetup()
        
        let filePath = Bundle.main.path(forResource: Configuration.getValue(for: .PROJECT_GOOGLE_PLIST), ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
        
        registerRemoteNotifications(application)
        VoIP_Registry()
        
        JitsiMeet.sharedInstance().defaultConferenceOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL.init(string: Configuration.getValue(for: .PROJECT_JITSI_SERVER))!
        }
        return JitsiMeet.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
    }
    
    //MARK:- Universal Links handling
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                    debugPrint("Universal Link Error: \(/error?.localizedDescription)")
                    return
                }
                if let link = dynamicLink {
                    self.handleIncomingDynamicLink(link: link)
                }
            }
            return linkHandled
        }
        return false
    }
    
    //MARK:- URL Scheme handling
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        #if Heal
        if url.scheme?.caseInsensitiveCompare(Configuration.getValue(for: .PROJECT_BUNDLE_ID)) == .orderedSame {
            handleHyperPayDeepLink(for: url)
            return true
        }
        #endif
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleIncomingDynamicLink(link: dynamicLink)
            return true
        } else {
            return /GIDSignIn.sharedInstance()?.handle(url) || ApplicationDelegate.shared.application(app, open: url, options: options)
        }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appForegroundAction()
    }
}

//MARK:- Custom functions
extension AppDelegate {
    public func setRootVC() {
        let navigationChooseAppVC = UINavigationController.init(rootViewController: Storyboard<ChooseAppVC>.LoginSignUp.instantiateVC())
        navigationChooseAppVC.navigationBar.isHidden = true
        let navigationIntroVC = UINavigationController.init(rootViewController: Storyboard<IntroVC>.LoginSignUp.instantiateVC())
        navigationIntroVC.navigationBar.isHidden = true
        let tabNavigationVC = Storyboard<NavgationTabVC>.TabBar.instantiateVC()
        let navigationLanguageVC = UINavigationController.init(rootViewController: Storyboard<LanguageVC>.LoginSignUp.instantiateVC())
        navigationLanguageVC.navigationBar.isHidden = true
        
        let navigationLocationVC = UINavigationController.init(rootViewController: Storyboard<LocationRequestVC>.LoginSignUp.instantiateVC())
        navigationLocationVC.navigationBar.isHidden = true
        
        if /UserPreference.shared.isLanguageScreenShown {
            if /UserPreference.shared.isChooseAppScreenShown {
                if /UserPreference.shared.isLocationScreenSeen {
                    setRoot(for: /UserPreference.shared.isIntroScreensSeen ? tabNavigationVC : navigationIntroVC)
                } else {
                    setRoot(for: navigationLocationVC)
                }
            } else {
                setRoot(for: navigationChooseAppVC)
            }
        } else {
            setRoot(for: navigationLanguageVC)
        }
    }
    
    public func setRoot(for vc: UIViewController) {
        window?.rootViewController = vc
        window?.tintColor = ColorAsset.appTint.color
        window?.makeKeyAndVisible()
        UIView.transition(with: window!, duration: 0.4, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
        }, completion: { _ in })
    }
    
    public func appForegroundAction() {
        EP_Home.appversion(app: .UserApp, version: Bundle.main.versionDecimalScrapped).request(success: { [weak self] (responseData) in
            guard let updateType = (responseData as? AppData)?.update_type else {
                return
            }
            self?.handleAppUpDate(updateType: updateType)
        })
        
        apiToFetchPage()
        
        EP_Home.masterPreferences(type: .All).request(success: { (responseData) in
            
        })
    }
    
    func apiToFetchPage() {
        EP_Home.pages.request(success: { (response) in
            UserPreference.shared.pages = response as? [Page]
        })
        
        
        EP_Home.getClientDetail(app: .UserApp).request(success: { (responeData) in
            if /UserPreference.shared.data?.token != "" {
                SocketIOManager.shared.connect(nil)
            }
        })
    }
    func handleAppUpDate(updateType: AppUpdateType) {
        let appURL = "http://itunes.apple.com/app/id\(Configuration.getValue(for: .PROJECT_APPLE_APP_ID))"
        switch updateType {
        case .NoUpdate:
            break
        case .MinorUpdate:
            UIApplication.topVC()?.alertBoxOKCancel(title: String.init(format: VCLiteral.UPDATE_TITLE.localized, "\(NSLocalizedString(Configuration.getValue(for: .PROJECT_APP_NAME), comment: ""))"), message: VCLiteral.UPDATE_DESC.localized, tapped: {
                UIApplication.shared.open(URL.init(string: appURL)!, options: [:], completionHandler: nil)
            }, cancelTapped: nil)
        case .MajorUpdate:
            UIApplication.topVC()?.alertBox(title: String.init(format: VCLiteral.UPDATE_TITLE.localized, "\(NSLocalizedString(Configuration.getValue(for: .PROJECT_APP_NAME), comment: ""))"), message: VCLiteral.UPDATE_DESC.localized, btn1: VCLiteral.OK.localized, btn2: nil, tapped1: {
                UIApplication.shared.open(URL.init(string: appURL)!, options: [:], completionHandler: nil)
            }, tapped2: nil)
        }
    }
    
    #if Heal
    func handleHyperPayDeepLink(for url: URL) {
        checkOutProvider?.dismissCheckout(animated: true, completion: {
            let resourcePath = url.absoluteString.components(separatedBy: "resourcePath=").last?.removingPercentEncoding
            (UIApplication.topVC() as? BaseVC)?.playLineAnimation()
            EP_Home.hyperPayWebHook(resource: resourcePath).request { (_) in
                (UIApplication.topVC() as? BaseVC)?.stopLineAnimation()
                UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
                UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
                UIApplication.topVC()?.popTo(toControllerType: PackagesVC.self)
            } error: { (_) in
                (UIApplication.topVC() as? BaseVC)?.stopLineAnimation()
            }
        })
    }
    #endif
    
    func handleIncomingDynamicLink(link: DynamicLink) {
        
        switch link.matchType {
        case .weak:
            return
        default:
            break
        }
        guard let url = link.url else {
            debugPrint("Dynamic link object has no url")
            return
        }
        debugPrint("Dynamic Link URL: \(url.absoluteString)")
        guard let components = URLComponents.init(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return
        }
        
        var dict = [String :Any]()
        
        for queryItem in queryItems {
            dict[/queryItem.name] = /queryItem.value
        }
        
    }
    
    func checkUserLoggedIn(showPopUp: Bool) -> Bool {
        if UserPreference.shared.data?.provider_type == .apple && /UserPreference.shared.data?.name != "" {
            return true
        }
        
        if /UserPreference.shared.data?.token == "" || /UserPreference.shared.data?.name == "" {
            if showPopUp {
                let loginAlert = Storyboard<LoginPopUpVC>.PopUp.instantiateVC()
                loginAlert.modalPresentationStyle = .overFullScreen
                loginAlert.didDismiss = { (providerType, callBack) in
                    switch callBack {
                    case .FB_GOOGLE:
                        #if NurseLynx
                        if /UserPreference.shared.data?.is_agreed {
                            UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
                        } else {
                            let destVC = Storyboard<SignUpInterMediateVC>.LoginSignUp.instantiateVC()
                            destVC.isViaSocialLogin = true
                            UIApplication.topVC()?.pushVC(destVC)
                        }
                        #else
                        if /UserPreference.shared.clientDetail?.openAddressInsuranceScreen() {
                            UIApplication.topVC()?.pushVC(Storyboard<AddressInsuranceVC>.LoginSignUp.instantiateVC())
                        } else {
                            UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
                        }
                        #endif
                    case .SIGNUP, .LOGIN:
                        let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
                        destVC.providerType = .phone
                        destVC.isLogin = callBack == .LOGIN
                        UIApplication.topVC()?.pushVC(destVC)
                    case .SIGNUP_EMAIL:
                        let destVC = Storyboard<SignUpVC>.LoginSignUp.instantiateVC()
                        UIApplication.topVC()?.pushVC(destVC)
                    case .DEFAULT:
                        break
                    case .TERMS_TAPPED:
                        let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                        destVC.linkTitle = ("\(/UserPreference.shared.clientDetail?.domain_url)/\(APIConstants.termsConditions)", VCLiteral.TERMS_AND_CONDITIONS.localized)
                        UIApplication.topVC()?.pushVC(destVC)
                    case .PRIVACY_TAPPED:
                        let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                        destVC.linkTitle = ("\(/UserPreference.shared.clientDetail?.domain_url)/\(APIConstants.privacyPolicy)", VCLiteral.PRIVACY.localized)
                        UIApplication.topVC()?.pushVC(destVC)
                    case .APPLE:
                        if /UserPreference.shared.data?.name?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                            let destVC = Storyboard<SignUpInterMediateVC>.LoginSignUp.instantiateVC()
                            destVC.isViaSocialLogin = true
                            UIApplication.topVC()?.pushVC(destVC)
                        } else {
                            UIWindow.replaceRootVC(Storyboard<NavgationTabVC>.TabBar.instantiateVC())
                        }
                    }
                }
                UIApplication.topVC()?.presentVC(loginAlert)
            }
            return false
        } else {
            return true
        }
    }
    
    private func IQ_KeyboaarManagerSetup() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(IQView.self)
        IQKeyboardManager.shared.toolbarTintColor = ColorAsset.appTint.color
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginEmailVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginMobileVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(VerificationVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(SignUpInterMediateVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(ShortLoginVC.self)
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(ChatVC.self)
        IQKeyboardManager.shared.disabledToolbarClasses.append(TipOfTheDayVC.self)
    }
}
