//
//  ExtraPaymentCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/02/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class ExtraPaymentCell: UITableViewCell, ReusableCell {

    typealias T = AppDetailCellModel
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnExtraPay: SKButton!
    
    var extraPaymentPaid: (() -> Void)?
    
    var item: AppDetailCellModel? {
        didSet {
            lblAmount.text = VCLiteral.AMOUNT.localized
            btnExtraPay.isHidden = item?.property?.model?.request?.extra_payment?.status == .paid
            lblAmountValue.text = /item?.property?.model?.request?.extra_payment?.balance?.getFormattedPrice()
            lblDesc.text = /item?.property?.model?.request?.extra_payment?.description
            btnExtraPay.setTitle(VCLiteral.PAY_EXTRA.localized, for: .normal)
        }
    }
    
    @IBAction func btnExtraPayAction(_ sender: SKLottieButton) {
        UIApplication.topVC()?.alertBoxOKCancel(title: VCLiteral.EXTRA_PAYMENT.localized, message: VCLiteral.EXTRA_PAY_MESSAGE.localized, tapped: { [weak self] in
            self?.payExtraAPI()
        }, cancelTapped: nil)
    }
    
    private func payExtraAPI() {
        btnExtraPay.playAnimation()
        EP_Home.payExtra(id: item?.property?.model?.request?.id).request { [weak self] (response) in
            self?.btnExtraPay.stop()
            let data = response as? CreateRequestData
            if /data?.amountNotSufficient {
                self?.showInvalidBalanceAlert(message: data?.message, minAmount: Double(/data?.minimum_balance))
            } else {
                self?.item?.property?.model?.request?.extra_payment?.status = .paid
                self?.extraPaymentPaid?()
            }
        } error: { [weak self] (error) in
            self?.btnExtraPay.stop()
        }
    }
    
    private func showInvalidBalanceAlert(message: String?, minAmount: Double?) {
        let minimumAmount = /minAmount?.getFormattedPrice()
        let defaultMessage = String(format: VCLiteral.WALLET_ALERT_MESSAGE.localized, minimumAmount)
        UIApplication.topVC()?.alertBox(title: VCLiteral.WALLET_ALERT.localized, message: message ?? defaultMessage, btn1: VCLiteral.ADD_MONEY.localized, btn2: VCLiteral.CANCEL.localized, tapped1: {
            let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
            UIApplication.topVC()?.pushVC(destVC)
        }, tapped2: nil)
    }
}
