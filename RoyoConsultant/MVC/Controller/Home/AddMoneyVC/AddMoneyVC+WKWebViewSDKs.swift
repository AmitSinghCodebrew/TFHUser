//
//  AddMoneyVC+WKWebViewSDKs.swift
//  HomeDoctorKhalid
//
//  Created by Sandeep Kumar on 22/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

extension AddMoneyVC {
    internal func addMoneyViaWebsiteTypeSDK() {
        //Al Razahi Test Creds
        //5105 1051 0510 5100
        //12 2025
        //999
        
        //PayStack
        EP_Home.addMoney(balance: tfAmount.text?.trimmingCharacters(in: .whitespacesAndNewlines), cardId: nil).request { [weak self] (responseData) in
            self?.btnPay.stop()
            let response = responseData as? StripeData
            let webVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            webVC.linkTitle = (/response?.url, "Payment")
            webVC.isPaymentGateway = true
            webVC.paymentSuccess = {
                UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
                UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
                UIApplication.topVC()?.popTo(toControllerType: PackagesVC.self)
            }
            self?.pushVC(webVC)
        } error: { [weak self] (_) in
            self?.btnPay.stop()
        }
    }
}
