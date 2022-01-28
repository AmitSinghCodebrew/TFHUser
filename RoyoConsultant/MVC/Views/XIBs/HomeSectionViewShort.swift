//
//  HomeSectionViewShort.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 29/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeSectionViewShort: UITableViewHeaderFooterView, ReusableHeaderFooter {
    typealias T = HomeSectionProvider
    
    @IBOutlet weak var lblTitleTop: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var btnMyQuestions: UIButton!
    @IBOutlet weak var lblCarePlan: UILabel!
    
    var didTapAction: ((_ action: HeaderActionType?) -> Void)?

    var item: HomeSectionProvider? {
        didSet {
            lblTitleTop.text = /item?.headerProperty?.model?.titleRegular?.localized
            lblCarePlan.isHidden = true
            lblTitleTop.isHidden = false

            if let extraPayment = item?.headerProperty?.model?.extraPayment {
                let text = VCLiteral.EXTRA_PAYMENT.localized + " " + "(\(/extraPayment.status?.title.localized))"
                lblTitleTop.setAtrributedText(original: (text, Fonts.CamptonMedium.ofSize(20), ColorAsset.txtMoreDark.color), toReplace: ("(\(/extraPayment.status?.title.localized))", Fonts.CamptonBook.ofSize(16), (extraPayment.status?.color)!))
            } else {
                #if NurseLynx
                if /item?.headerProperty?.model?.titleRegular?.localized == VCLiteral.CARE_PLAN.localized {
                    lblCarePlan.numberOfLines = 0
                    let text = "\(VCLiteral.CARE_PLAN.localized)\n\(/item?.headerProperty?.model?.tier?.title)"
                    lblCarePlan.setAttributedText(original: (text, Fonts.CamptonSemiBold.ofSize(16), ColorAsset.txtMoreDark.color), toReplace: (/item?.headerProperty?.model?.tier?.title, Fonts.CamptonMedium.ofSize(12), ColorAsset.txtDark.color))
                    lblCarePlan.isHidden = false
                    lblTitleTop.isHidden = true
                } else {
                    lblCarePlan.isHidden = true
                    lblTitleTop.setAtrributedText(original: (/item?.headerProperty?.model?.titleBold?.localized, Fonts.CamptonMedium.ofSize(20), ColorAsset.txtMoreDark.color), toReplace: ("", Fonts.CamptonMedium.ofSize(20), ColorAsset.txtMoreDark.color))
                    lblTitleTop.isHidden = false
                }
                #else
                lblTitleTop.setAtrributedText(original: (/item?.headerProperty?.model?.titleBold?.localized, Fonts.CamptonMedium.ofSize(20), ColorAsset.txtMoreDark.color), toReplace: ("", Fonts.CamptonMedium.ofSize(20), ColorAsset.txtMoreDark.color))
                lblCarePlan.isHidden = true
                lblTitleTop.isHidden = false

                #endif

            }
            
            btn.setTitle(/item?.headerProperty?.model?.btnText?.localized, for: .normal)
            btn.isHidden = /item?.headerProperty?.model?.isBtnHidden
            btnMyQuestions.isHidden = !(/item?.headerProperty?.model?.titleRegular?.localized == VCLiteral.ASK_FREE_QUESTIONS.localized)
        }
    }
    
    //ApptDetail VC
    var item2: ApptDetailHeader? {
        didSet {
            item = HomeSectionProvider.init(item2?.headerProperty, nil, [])
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //View All
            didTapAction?(item?.headerProperty?.model?.action)
        case 1: //My Questions //HealthCarePrashant
            if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
                didTapAction?(.MyQuestions)
            }
        default:
            break
        }
        
    }

}
