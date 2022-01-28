//
//  SubCategoryCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SubCategoryCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgViewLeft: UIImageView!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    var imageSize: CGSize?

    var item: Any? {
        didSet {
            let obj = item as? Category
            lblTitle.text = /obj?.name
            lblTitle.textColor = AppSettings.mainCategoryTextColor
            backView.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
            switch AppSettings.categoryImageAlign {
            case .Left:
                imgViewLeft.setCategoryImage(imageOrURL: /obj?.image, size: imageSize ?? CGSize.zero, contentMode: .bottomLeft)
                lblTitle.textAlignment = .right
                imgView.isHidden = true
                leading.constant = 48
                trailing.constant = 16
            case .Right:
                imgViewLeft.isHidden = true
                lblTitle.textAlignment = L102Language.isRTL ? .right : .left
                imgView.setCategoryImage(imageOrURL: /obj?.image, size: imageSize ?? CGSize.zero, contentMode: L102Language.isRTL ? .bottomLeft : .bottomRight)
                leading.constant = 16
                trailing.constant = 48
            }
        }
    }
}
