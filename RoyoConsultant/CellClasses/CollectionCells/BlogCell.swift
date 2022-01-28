//
//  BlogCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 31/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class BlogCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    public var feedType: FeedType?
    
    var item: Any? {
        didSet {
            imgView.backgroundColor = ColorAsset.appTint.color
            let obj = item as? Feed
            imgView.setImageNuke(obj?.image)
            lblTitle.text = /obj?.title
            let date = Date.init(fromString: /obj?.created_at, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            if feedType == .question {
                lblDate.font = Fonts.CamptonMedium.ofSize(12)
                lblDate.text = VCLiteral.GET_ADVICE.localized
                lblDate.textColor = ColorAsset.appTintAlternate.color
            } else {
                lblDate.font = Fonts.CamptonLight.ofSize(12)
                lblDate.textColor = ColorAsset.txtLightGrey.color
                lblDate.text = /date.toString(DateFormat.custom(UserPreference.shared.dateFormat), isForAPI: false)
            }
        }
    }
}
