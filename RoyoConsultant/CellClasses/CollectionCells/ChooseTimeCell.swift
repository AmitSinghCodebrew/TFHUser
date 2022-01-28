//
//  ChooseTimeCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ChooseTimeCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTime: UILabel!
    
    
    var item: Any? {
        didSet {
            let interval = item as? Interval
            lblTime.text = /interval?.time?.uppercased()
            if /interval?.isSelected {
                viewBack.backgroundColor = ColorAsset.appTint.color
                viewBack.borderColor = ColorAsset.appTint.color
                lblTime.textColor = ColorAsset.txtWhite.color
            } else {
                viewBack.backgroundColor = ColorAsset.backgroundCell.color
                viewBack.borderColor = (/interval?.available) ? ColorAsset.txtGrey.color : ColorAsset.appTintExtraLight.color
                lblTime.textColor = (/interval?.available) ? ColorAsset.txtMoreDark.color : ColorAsset.appTintExtraLight.color
            }
        }
    }
}
