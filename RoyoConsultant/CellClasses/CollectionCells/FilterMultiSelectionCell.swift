//
//  FilterMultiSelectionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 05/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class FilterMultiSelectionCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var viewTick: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    var item: Any? {
        didSet {
            lblName.text = /(item as? FilterOption)?.option_name
            viewTick.isHidden = !(/(item as? FilterOption)?.isSelected)
        }
    }
    
    
}
