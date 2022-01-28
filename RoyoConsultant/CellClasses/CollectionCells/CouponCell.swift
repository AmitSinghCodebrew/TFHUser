//
//  CouponCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 08/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class CouponCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblUseCode: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    var item: Any? {
        didSet {
            let obj = item as? Coupon
            lblCode.text = /obj?.coupon_code
            lblUseCode.text = VCLiteral.USE_CODE.localized
            let usersRemaining = String.init(format: /obj?.limit == 1 ? VCLiteral.USER_REMAINING.localized : VCLiteral.USERS_REMAINING.localized, "\(/obj?.limit)")
            lblTitle2.setAttributedText(original: (usersRemaining, Fonts.CamptonLight.ofSize(12), ColorAsset.txtMoreDark.color), toReplace: ("\(/obj?.limit)", Fonts.CamptonMedium.ofSize(12), ColorAsset.txtMoreDark.color))
            
            
            let lastDate = Date.init(fromString: /obj?.end_date, format: DateFormat.custom("yyyy-MM-dd"), timeZone: .utc).toString(DateFormat.custom("MMMM dd, yyyy"), timeZone: .local, isForAPI: false)
            let serviceOrCategory = obj?.service == nil ? /obj?.category?.name?.capitalizingFirstLetter() : /obj?.service?.name?.capitalizingFirstLetter()
            let discountText = obj?.discount_type == .percentage ? "\(/obj?.discount_value)%" : /obj?.discount_value?.toDouble()?.getFormattedPrice()
            
            let textNormal = String.init(format: VCLiteral.COUPON_TITLE.localized, discountText, serviceOrCategory, lastDate)
            
            lblTitle1.setAttributedText(original:
                (textNormal, Fonts.CamptonBook.ofSize(14.0), ColorAsset.txtMoreDark.color),
                                         toReplace:
                                        (discountText, Fonts.CamptonMedium.ofSize(14.0), ColorAsset.txtMoreDark.color),
                                         (serviceOrCategory, Fonts.CamptonMedium.ofSize(14.0), ColorAsset.txtMoreDark.color),
                                         (lastDate, Fonts.CamptonMedium.ofSize(14.0), ColorAsset.txtMoreDark.color))
        }
    }
}
