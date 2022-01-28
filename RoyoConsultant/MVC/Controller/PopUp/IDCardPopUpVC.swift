//
//  IDCardPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 03/06/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class IDCardPopUpVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameValue: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblEmailValue: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPhoneValue: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblDOBValue: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPopUpWithAnimation()
        localizedTextSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        hideVisulEffectView()
    }

}

//MARK:- VCFuncs
extension IDCardPopUpVC {
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = Configuration.appName()
        
        let user = UserPreference.shared.data
        lblName.text = VCLiteral.NAME_PLACEHOLDER.localized
        lblEmail.text = VCLiteral.EMAIL_PLACEHOLDER.localized
        lblPhone.text = VCLiteral.PHONE.localized
        lblDOB.text = VCLiteral.DOB.localized
        lblNameValue.text = /user?.name
        lblEmailValue.text = user?.email ?? VCLiteral.NA.localized
        lblPhoneValue.text = /user?.phone == "" ? VCLiteral.NA.localized : "\(/user?.country_code)-\(/user?.phone)"
        lblDOBValue.text = /user?.dob == "" ? VCLiteral.NA.localized : Date.init(fromString: /user?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom(UserPreference.shared.dateFormat), timeZone: .local, isForAPI: false)
        
        imgView.setImageNuke(/user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))

    }
    
    private func hideVisulEffectView() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.removePopUp()
        }
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
}
