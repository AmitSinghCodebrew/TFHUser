//
//  AboutCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider
    
    @IBOutlet weak var lblDesc: SK_TTT_Label!
    var reloadCell: (() -> Void)?
    
    var item: VD_Cell_Provider? {
        didSet {
            lblDesc.showText(str: /item?.property?.model?.about?.text, readMoreText: VCLiteral.READ_MORE.localized, readLessText: VCLiteral.READ_LESS.localized, charatersBeforeReadMore: 80, isReadMoreTapped: /item?.property?.model?.about?.isAllText, attr: [NSAttributedString.Key.font: Fonts.CamptonBook.ofSize(14.0),
                                                                                                                                                                                                                                      NSAttributedString.Key.foregroundColor: ColorAsset.txtDark.color], btnAttr: [NSAttributedString.Key.font: Fonts.CamptonMedium.ofSize(14.0),
                                                                                                                                                                                                                                                                                                                   NSAttributedString.Key.foregroundColor: ColorAsset.txtDark.color])
            lblDesc.didTapReadMoreOrLess = { [weak self] in
                self?.item?.property?.model?.about = (self?.item?.property?.model?.about?.text, !(/self?.item?.property?.model?.about?.isAllText))
                self?.reloadCell?()
            }
        }
    }
}

