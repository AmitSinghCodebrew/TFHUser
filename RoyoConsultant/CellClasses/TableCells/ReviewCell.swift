//
//  ReviewCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReview: SK_TTT_Label!
    
    var reloadCell: (() -> Void)?

    var item: VD_Cell_Provider? {
        didSet {
            let review = item?.property?.model?.review
            imgView.setImageNuke(/review?.user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /review?.user?.name?.capitalizingFirstLetter()
            lblReview.showText(str: /review?.comment, readMoreText: VCLiteral.READ_MORE.localized, readLessText: VCLiteral.READ_LESS.localized, charatersBeforeReadMore: 80, isReadMoreTapped: /item?.property?.model?.review?.isReadMoreTapped, attr: [NSAttributedString.Key.font: Fonts.CamptonBook.ofSize(12.0),
                                                                                                                                                                                                                                      NSAttributedString.Key.foregroundColor: ColorAsset.txtDark.color], btnAttr: [NSAttributedString.Key.font: Fonts.CamptonMedium.ofSize(12.0),
                                                                                                                                                                                                                                                                                                                   NSAttributedString.Key.foregroundColor: ColorAsset.txtDark.color])
            lblRating.text = String(/review?.rating)
            lblReview.didTapReadMoreOrLess = { [weak self] in
                self?.item?.property?.model?.review?.isReadMoreTapped = !(/self?.item?.property?.model?.review?.isReadMoreTapped)
                self?.reloadCell?()
            }
        }
    }
    

}
