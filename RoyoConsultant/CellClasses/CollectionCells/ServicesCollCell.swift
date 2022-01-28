//
//  CategoriesCell.swift
//  RoyoConsultant
//
//  Created by Chitresh Goyal on 04/08/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class ServicesCollCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var backView: GradientView!
    @IBOutlet weak var lblText: UILabel!
    
    var item: Any? {
        didSet {
            let obj = item as? Service
            lblText.text = /obj?.name?.capitalizingFirstLetter()
            backView.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
        }
    }
}
