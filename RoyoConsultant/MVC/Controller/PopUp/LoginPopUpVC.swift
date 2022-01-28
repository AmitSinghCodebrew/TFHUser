//
//  LoginPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
enum CallBackType {
    case FB_GOOGLE
    case DEFAULT
    case TERMS_TAPPED
    case PRIVACY_TAPPED
    case APPLE
    case SIGNUP
    case LOGIN
    case SIGNUP_EMAIL
}

class LoginPopUpVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblSignUpText: UILabel!
    @IBOutlet weak var lblFacebookText: UILabel!
    @IBOutlet weak var lblGoogleText: UILabel!
    @IBOutlet weak var lblContinueToAgree: UILabel!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewForLottie: UIView!
    @IBOutlet weak var appleBtn: AppleSignInButton!
    @IBOutlet weak var lblAccountToContinue: UILabel!
    @IBOutlet weak var lblSignupEmail: UILabel!
    
    public var didDismiss: ((_ provider: ProviderType?, _ callBackType: CallBackType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        appleBtn.didCompletedSignIn = { (data) in
            self.loginAPI(providerType: .apple, loginData: data, callBack: .APPLE)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            hideVisulEffectView(provider: nil, callBack: .DEFAULT)
        case 1: //SignUp Phone number
            hideVisulEffectView(provider: nil, callBack: .SIGNUP)
        case 2: //Facebook
            FBLogin.shared.login { [weak self] (loginData) in
                self?.loginAPI(providerType: .facebook, loginData: loginData, callBack: .FB_GOOGLE)
            }
        case 3: //Google
            GoogleSignIn.shared.openGoogleSigin { [weak self] (loginData) in
                self?.loginAPI(providerType: .google, loginData: loginData, callBack: .FB_GOOGLE)
            }
        case 4: //Terms of service
            hideVisulEffectView(provider: nil, callBack: .TERMS_TAPPED)
        case 5: //Privacy policy
            hideVisulEffectView(provider: nil, callBack: .PRIVACY_TAPPED)
        case 6: //Login
            hideVisulEffectView(provider: nil, callBack: .LOGIN)
        case 7: //SignUp Email
            hideVisulEffectView(provider: nil, callBack: .SIGNUP_EMAIL)
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension LoginPopUpVC {
    
    private func loginAPI(providerType: ProviderType, loginData: GoogleAppleFBUserData?, callBack: CallBackType) {
        startAnimation()
        EP_Login.login(provider_type: providerType, provider_id: nil, provider_verification: /loginData?.accessToken, user_type: .customer, country_code: nil, is_agreed: nil).request(success: { [weak self] (response) in
            self?.stopAnimation()
            self?.hideVisulEffectView(provider: providerType, callBack: callBack)
        }) { [weak self] (error) in
            self?.stopAnimation()
        }
    }
    
    
    private func startAnimation() {
        view.isUserInteractionEnabled = false
        lineAnimation.removeFromSuperview()
        let width = UIScreen.main.bounds.width
        let height = width * (5 / 450)
        lineAnimation.frame = CGRect.init(x: 0, y: 0, width: width, height: height - 2.0)
        viewForLottie.addSubview(lineAnimation)
        lineAnimation.clipsToBounds = true
        lineAnimation.play()
    }
    
    private func stopAnimation() {
        lineAnimation.stop()
        lineAnimation.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    private func localizedTextSetup() {
        
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
//        lblAccountToContinue.text = VCLiteral.ACCOUNT_TO_CONTINUE.localized
        
        #if HomeDoctorKhalid
        lblAccountToContinue.text = VCLiteral.ACCOUNT_TO_CONTINUE.localized
        #else
        let fullText = String.init(format: VCLiteral.ACCOUNT_TO_CONTINUE.localized, Configuration.appName())
        lblAccountToContinue.setAttributedText(original: (fullText, Fonts.CamptonMedium.ofSize(16), ColorAsset.txtMoreDark.color), toReplace: (Configuration.appName(), Fonts.CamptonSemiBold.ofSize(16), ColorAsset.appTint.color))

        #endif
        lblSignUpText.text = VCLiteral.SIGNUP_USING_MOBILE.localized
        lblFacebookText.text = VCLiteral.FACEBOOK.localized
        lblGoogleText.text = VCLiteral.GOOGLE.localized
        lblContinueToAgree.text = VCLiteral.BY_CONTINUE.localized
        btnTerms.setTitle(VCLiteral.TERMS.localized, for: .normal)
        lblAnd.text = VCLiteral.AND.localized
        btnPrivacy.setTitle(VCLiteral.PRIVACY.localized, for: .normal)
        lblAlreadyAccount.text = VCLiteral.ALREADY_ACCOUNT.localized
        btnLogin.setTitle(VCLiteral.LOGIN.localized, for: .normal)
        lblSignupEmail.text = VCLiteral.SIGNUP_USING_EMAIL.localized
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView(provider: ProviderType?, callBack: CallBackType) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                self?.didDismiss?(provider, callBack)
            })
        }
    }
}
