//
//  FilterSingleSelectionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 05/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class FilterSingleSelectionCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var viewDot: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    var item: Any? {
        didSet {
            lblName.text = /(item as? FilterOption)?.option_name
            viewDot.isHidden = !(/(item as? FilterOption)?.isSelected)
        }
    }
    
}
