//
//  OptionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 20/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
 
    var item: Any? {
        didSet {
            let obj = item as? Symptom
            lblTitle.text = /obj?.name
            viewBack.backgroundColor = /obj?.isSelected ? ColorAsset.appTint.color : ColorAsset.backgroundCell.color
            lblTitle.textColor = /obj?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.appTint.color
        }
    }
}
