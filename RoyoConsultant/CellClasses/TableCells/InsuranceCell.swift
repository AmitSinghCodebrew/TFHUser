//
//  InsuranceCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class InsuranceCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var lblText: UILabel!
    
    typealias T = DefaultCellModel<Insurance>
    
    var item: DefaultCellModel<Insurance>? {
        didSet {
            lblText.text = /item?.property?.model?.name
            backgroundColor = /item?.property?.model?.isSelected ? ColorAsset.appTint.color : ColorAsset.backgroundCell.color
            lblText.textColor = /item?.property?.model?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtMoreDark.color
        }
    }
    
}
