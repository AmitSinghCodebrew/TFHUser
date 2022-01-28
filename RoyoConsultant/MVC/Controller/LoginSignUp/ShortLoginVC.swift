//
//  ShortLoginVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ShortLoginVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfName: JVFloatLabeledTextField!
    
    private var countryPicker: CountryManager?
    private var currentCountry: CountryISO?
    public var providerType: ProviderType = .phone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCountryCode.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(presentCountryPicker)))
        countryPicker = CountryManager()
        currentCountry = countryPicker?.currentCountry
        localizedTextSetup()
        
        nextBtnAccessory.didTapContinue = { [weak self] in
            let btn = UIButton.init()
            btn.tag = 1
            self?.btnBackAction(btn)
        }
        
        tfResponder = TFResponder()
        tfResponder?.addResponders([TVTF.TF(tfPhone), TVTF.TF(tfName)])
        tfPhone.becomeFirstResponder()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        return nextBtnAccessory
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Next
            switch Validation.shared.validate(values: (.PHONE, /tfPhone.text), (.NAME, /tfName.text)) {
            case .success:
                loginAPI()
            case .failure(let alertType, let message):
                Toast.shared.showAlert(type: alertType, message: message.localized)
            }
        default:
            break
        }
    }
    
}

//MARK:- VCFuncs
extension ShortLoginVC {
    @objc private func presentCountryPicker() {
        countryPicker?.openCountryPicker({ [weak self] (country) in
            self?.currentCountry = country
            self?.lblCountryCode.text = "\(/self?.currentCountry?.Flag) \(/self?.currentCountry?.ISO) +\(/self?.currentCountry?.CC)"
        })
    }
    
    private func loginAPI() {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        nextBtnAccessory.startAnimation()
        
        EP_Login.sendOTP(phone: /tfPhone.text, countryCode: "+\(/currentCountry?.CC)").request(success: { [weak self] (responseData) in
            self?.nextBtnAccessory.stopAnimation()
            self?.view.isUserInteractionEnabled = true
            let destVC = Storyboard<VerificationVC>.LoginSignUp.instantiateVC()
            destVC.phone = (/self?.currentCountry?.CC, /self?.tfPhone.text)
            destVC.providerType = self?.providerType ?? .phone
            destVC.verifyType = .HomeVisit(name: /self?.tfName.text, type: .home_visit)
            self?.pushVC(destVC)
        }) { [weak self] (error) in
            self?.nextBtnAccessory.stopAnimation()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.LOGIN_FOR_HOME_VISIT.localized
        lblSubTitle.text = VCLiteral.LOGIN_USING_MOBILE_DESC.localized
        tfPhone.placeholder = VCLiteral.MOBILE_PACEHOLDER.localized
        lblCountryCode.text = "\(/currentCountry?.Flag) \(/currentCountry?.ISO) +\(/currentCountry?.CC)"
        tfName.placeholder = VCLiteral.NAME_PLACEHOLDER.localized
    }
}
