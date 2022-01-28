//
//  AddMoneyVC+HyperPay.swift
//  Heal
//
//  Created by Sandeep Kumar on 22/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
//Test Card 4111111111111111 05/21 cvv 123
//MARK:- HyperPay
extension AddMoneyVC {
    internal func showCardOptions() {
        actionSheet(for: [VCLiteral.HYPER_PAY_TYPE_MADA.localized, VCLiteral.HYPER_PAY_TYPE_MASTER_VISA.localized], title: nil, message: nil) { [weak self] (tappedType) in
            switch /tappedType {
            case VCLiteral.HYPER_PAY_TYPE_MADA.localized:
                self?.addMoneyViaHyperPay(type: .Mada)
            case VCLiteral.HYPER_PAY_TYPE_MASTER_VISA.localized:
                self?.addMoneyViaHyperPay(type: .visa_master)
            default:
                break
            }
        }
    }
    
    private func addMoneyViaHyperPay(type: HyperPayCardType) {
        btnPay.playAnimation()
        let amount = /Int(/tfAmount.text) * 100

        EP_Home.orderCreate(balance: String(amount), packageId: nil, paymentMethod: type).request { [weak self] (responseData) in
            let order = responseData as? Order
            self?.btnPay.stop()
            self?.openHyperPay(for: order)
        } error: { [weak self] (error) in
            self?.btnPay.stop()
        }
    }
    
    private func openHyperPay(for order: Order?) {
        let checkoutSettings = OPPCheckoutSettings()
        checkoutSettings.theme.accentColor = ColorAsset.appTint.color
        checkoutSettings.theme.navigationBarTintColor = ColorAsset.txtWhite.color
        checkoutSettings.theme.navigationBarBackgroundColor = ColorAsset.appTint.color
        checkoutSettings.theme.primaryBackgroundColor = ColorAsset.backgroundColor.color
        checkoutSettings.theme.primaryFont = Fonts.CamptonBook.ofSize(14)
        checkoutSettings.theme.sectionTextColor = ColorAsset.txtMoreDark.color
        checkoutSettings.theme.textFieldTextColor = ColorAsset.txtMoreDark.color
        checkoutSettings.theme.textFieldPlaceholderColor = ColorAsset.txtExtraLight.color
        checkoutSettings.theme.paymentBrandIconBorderColor = ColorAsset.appTint.color
        checkoutSettings.theme.paymentBrandIconBackgroundColor = ColorAsset.appTint.color
        checkoutSettings.theme.textFieldFont = Fonts.CamptonBook.ofSize(14)
        checkoutSettings.theme.textFieldBorderColor = ColorAsset.appTint.color
        checkoutSettings.theme.primaryForegroundColor = ColorAsset.appTint.color
        checkoutSettings.theme.confirmationButtonColor = ColorAsset.appTint.color
        checkoutSettings.theme.cellHighlightedTextColor = ColorAsset.appTint.color
        checkoutSettings.paymentBrands = ["VISA", "MASTER", "MADA", "APPLEPAY"]
        checkoutSettings.shopperResultURL = "\(Configuration.getValue(for: .PROJECT_BUNDLE_ID))://result"
        
        let paymentRequest = OPPPaymentProvider.paymentRequest(withMerchantIdentifier: "xxxxxxx", countryCode: "SA")
        
        paymentRequest.supportedNetworks = [.visa,.masterCard,.mada]
        if #available(iOS 11.0, *) {
            paymentRequest.requiredShippingContactFields = Set([PKContactField.postalAddress,PKContactField.emailAddress,PKContactField.name,.phoneNumber])
        } else {
            paymentRequest.requiredShippingAddressFields = [.postalAddress,.email,.name,.phone]
        }
        if #available(iOS 11.0, *) {
            paymentRequest.requiredBillingContactFields = Set([PKContactField.postalAddress,PKContactField.emailAddress,PKContactField.name,.phoneNumber])
        } else {
            paymentRequest.requiredBillingAddressFields = [.postalAddress,.email,.name,.phone]
        }
        checkoutSettings.applePayPaymentRequest = paymentRequest
        
        let checkoutProvider = OPPCheckoutProvider.init(paymentProvider: OPPPaymentProvider.init(mode: UserPreference.shared.clientDetail?.payment_provider_mode == .live ? .live: .test), checkoutID: /order?.order_id, settings: checkoutSettings)
                (UIApplication.shared.delegate as? AppDelegate)?.checkOutProvider = checkoutProvider
        checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in

        }, cancelHandler: {
            
        })
    }
}

