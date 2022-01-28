//
//  AddMoneyVC+RazorPay.swift
//  Heal
//
//  Created by Sandeep Kumar on 22/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Razorpay
//MARK:- RazorPay
extension AddMoneyVC: RazorpayPaymentCompletionProtocol {
    
    internal func addMoneyViaRazorPay() {
        let amount = /Int(/tfAmount.text) * 100
        EP_Home.orderCreate(balance: String(amount), packageId: nil, paymentMethod: nil).request { [weak self] (responseData) in
            let order = responseData as? Order
            self?.btnPay.stop()
            self?.showRazorPayPaymentForm(for: order?.order_id)
        } error: { [weak self] (error) in
            self?.btnPay.stop()
        }
    }
    
    internal func showRazorPayPaymentForm(for orderId: String?) {
        let amount = /Int(/tfAmount.text) * 100
        razorpayOrderId = orderId
        let options: [String:Any] = [
            "amount": String(amount), //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": /UserPreference.shared.clientDetail?.currency,//We support more that 92 international currencies.
                    "description": "purchase description",
                    "order_id": /orderId,
                    "image": Configuration.getValue(for: .PROJECT_IMAGE_UPLOAD) + /UserPreference.shared.clientDetail?.applogo,
            "name": Configuration.getValue(for: .PROJECT_APP_NAME),
                    "prefill": [
                        "contact": UserPreference.shared.data?.phone,
                        "email": UserPreference.shared.data?.email
                    ],
                    "theme": [
                        "color": /ColorAsset.appTint.color.hexString
                      ]
                ]
        razorpay.open(options)
    }
    
    internal func onPaymentError(_ code: Int32, description str: String) {
        Toast.shared.showAlert(type: .apiFailure, message: description)
    }
    
    internal func onPaymentSuccess(_ payment_id: String) {
        playWalletAnimation()
        EP_Home.razorPayWebhook(order_id: razorpayOrderId, razorpayPaymentId: payment_id).request { [weak self] (resposneData) in
            self?.stopWalletAnimation()
            UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
            UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
            UIApplication.topVC()?.popTo(toControllerType: PackagesVC.self)
        } error: { [weak self] (error) in
            self?.stopWalletAnimation()
            Toast.shared.showAlert(type: .apiFailure, message: /error)
            UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
            UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
            UIApplication.topVC()?.popTo(toControllerType: PackagesVC.self)
        }
    }
}
