//
//  SubCategoryCenterCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 28/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SubCategoryCenterCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var item: Any? {
        didSet {
            let obj = item as? Category
            lblTitle.text = /obj?.name
            backView.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
            imgView.setImageNuke(/obj?.image)
        }
    }
}
