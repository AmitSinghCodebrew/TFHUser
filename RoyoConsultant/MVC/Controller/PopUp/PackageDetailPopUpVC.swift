//
//  PacakgeDetailPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class PackageDetailPopUpVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnPay: SKButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var package: Package? //sender package object or packageId
    var packageId: Int?
    var callBack: ((_ _PackagePopUpCallBackType: PackagePopUpCallBackType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        setData()
        getDetailAPI()
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
            hideVisulEffectView(callBack: .DEFAULT)
        case 1: //Pay
            payAlert()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension PackageDetailPopUpVC {
    private func getDetailAPI() {
        EP_Home.packageDetail(id: packageId).request(success: { [weak self] (responseData) in
            self?.package = (responseData as? PackagesData)?.detail
            self?.setData()
        }) { (_) in

        }
    }
    
    private func payAlert() {
        alertBoxOKCancel(title: VCLiteral.PAY.localized, message: String.init(format: VCLiteral.PAY_ALERT_MESSAGE.localized, /package?.price?.getFormattedPrice()), tapped: { [weak self] in
            self?.buyPackageAPI()
        }, cancelTapped: nil)
    }
    
    private func buyPackageAPI() {
        btnPay.playAnimation()
        EP_Home.buyPackage(planId: package?.id).request(success: { [weak self] (responseData) in
            self?.btnPay.stop()
            /(responseData as? PackagesData)?.amountNotSufficient ? self?.showInvalidBalanceAlert() : self?.hideVisulEffectView(callBack: .DEFAULT)
        }) { [weak self] (_) in
            self?.btnPay.stop()
        }
    }
    
    private func showInvalidBalanceAlert() {
        let minimumAmount = /(200.0).getFormattedPrice()
        UIApplication.topVC()?.alertBox(title: VCLiteral.WALLET_ALERT.localized, message: String(format: VCLiteral.WALLET_ALERT_MESSAGE_PACKAGE.localized, minimumAmount), btn1: VCLiteral.ADD_MONEY.localized, btn2: VCLiteral.CANCEL.localized, tapped1: {
            self.hideVisulEffectView(callBack: .INVALID_BALANCE)
        }, tapped2: nil)
    }
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        btnPay.setTitle(VCLiteral.PAY.localized, for: .normal)
        imgView.roundCorners(with: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 24.0)
        btnPay.setAnimationType(.BtnWhiteLoader)
    }
    
    private func setData() {
        if let pack = package {
            imgView.setImageNuke(pack.image)
            lblTitle.text = /pack.title
            #if CloudDoc
            if /pack.subscribe {
                //2022-03-31 23:59:59
                let date = Date.init(fromString: /pack.expired_on_plan, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss")).toString(.custom(UserPreference.shared.dateFormat), timeZone: .local, isForAPI: false)
                lblDesc.text = "\(VCLiteral.AVAILABLE_REQUESTS.localized) \(String(/pack.available_requests))\n\(VCLiteral.EXPIRING_ON.localized) \(date)"
            } else {
                lblDesc.text = "\(VCLiteral.TOTAL_REQUESTS.localized) \(String(/pack.total_requests))"
            }
            #else
            lblDesc.text = /pack.description
            #endif
            btnPay.setTitle(/pack.subscribe ? "Paid" : String.init(format: VCLiteral.PAY_AMOUNT.localized, /pack.price == 0.0 ? "" : /pack.price?.getFormattedPrice()), for: .normal)
            packageId = pack.id
            btnPay.setTitleColor(/pack.subscribe ? ColorAsset.appTint.color : ColorAsset.txtWhite.color, for: .normal)
            btnPay.backgroundColor = /pack.subscribe ? UIColor.clear : ColorAsset.appTint.color
            btnPay.isUserInteractionEnabled = !(/pack.subscribe)
            if pack.subscribe == nil {
                btnPay.isUserInteractionEnabled = false
            }
        } else {
            lblTitle.text = ""
            lblDesc.text = ""
        }
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView(callBack: PackagePopUpCallBackType) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                self?.callBack?(callBack)
            })
        }
    }
    
    enum PackagePopUpCallBackType {
        case DEFAULT
        case INVALID_BALANCE
    }
}
