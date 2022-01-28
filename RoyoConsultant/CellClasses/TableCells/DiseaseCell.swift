//
//  DiseaseCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 27/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class DiseaseCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var lblText: UILabel!
    
    typealias T = DefaultCellModel<Disease>
    
    var item: DefaultCellModel<Disease>? {
        didSet {
            lblText.text = /item?.property?.model?.title?.localized
            backgroundColor = /item?.property?.model?.isSelected ? ColorAsset.appTint.color : ColorAsset.backgroundCell.color
            lblText.textColor = /item?.property?.model?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtMoreDark.color
        }
    }
}
