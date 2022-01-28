//
//  ProfileDetailVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ProfileDetailVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: SKLottieButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var viewBio: ViewProfileTitleValue!
    @IBOutlet weak var viewEmail: ViewProfileTitleValue!
    @IBOutlet weak var viewPhone: ViewProfileTitleValue!
    @IBOutlet weak var viewDOB: ViewProfileTitleValue!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dataSetup()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Edit
            pushVC(Storyboard<EditProfileVC>.Home.instantiateVC())
        default:
            break
        }
    }
    
    private func dataSetup() {
        let profile = UserPreference.shared.data
        lblTitle.text = VCLiteral.PROFILE.localized
        btnEdit.setTitle(VCLiteral.EDIT.localized, for: .normal)
        imgView.setImageNuke(/profile?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
        lblName.text = "\(/profile?.profile?.title) \(/profile?.name)".trimmingCharacters(in: .whitespaces)
        var age = VCLiteral.NA.localized
        if /profile?.profile?.dob != "" {
            let tempAge = Date().year() - /Date.init(fromString: /profile?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).year()
            age = (tempAge == 0 ? VCLiteral.NA.localized : "\(tempAge)")
        }
        lblAge.text = String.init(format: VCLiteral.AGE.localized, age)
        
        viewBio.isHidden = /profile?.profile?.bio == ""
        viewBio.setData(title: .BIO_PLACEHOLDER, value: /profile?.profile?.bio, btnTitle: nil, nil)
        
        viewEmail.isHidden = /profile?.email == ""
        viewEmail.setData(title: .EMAIL_PLACEHOLDER, value: /profile?.email, btnTitle: nil, nil)
        
        viewPhone.setData(title: .PHONE_NUMBER, value: /profile?.phone == "" ? VCLiteral.NA.localized : "\(/profile?.country_code)-\(/profile?.phone)", btnTitle: .UPDATE) { [weak self] in
            let destVC = Storyboard<LoginMobileVC>.LoginSignUp.instantiateVC()
            destVC.providerType = .updatePhone
            self?.pushVC(destVC)
        }
        
        viewDOB.isHidden = /profile?.profile?.dob == ""
        viewDOB.setData(title: .DOB_PLACEHOLDER, value: Date.init(fromString: /profile?.profile?.dob, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom(UserPreference.shared.dateFormat), timeZone: .local, isForAPI: false), btnTitle: nil, nil)
        #if HealthCarePrashant
        viewDOB.isHidden = true
        viewLocation.isHidden = false
        lblLocation.text = /LocationManager.shared.address?.name
        lblAge.isHidden = true
        #else
        viewLocation.isHidden = true
        #endif
    }
}

class ViewProfileTitleValue: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btn: UIButton?
    
    private var btnTapped: (() -> Void)?
    
    @IBAction func btnAction(_ sender: UIButton) {
        btnTapped?()
    }
    
    public func setData(title: VCLiteral, value: String, btnTitle: VCLiteral?, _ _btnTapped: (() -> Void)?) {
        lblTitle.text = title.localized
        lblValue.text = value
        btn?.setTitle(/btnTitle?.localized, for: .normal)
        btnTapped = _btnTapped
    }
}
