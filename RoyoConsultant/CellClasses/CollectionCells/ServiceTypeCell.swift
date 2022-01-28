//
//  ServiceTypeCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 29/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ServiceTypeCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var viewbackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var item: Any? {
        didSet {
            let obj = item as? CustomService
            lblTitle.text = /obj?.title?.localized
            imgView.image = obj?.image
            viewbackground.backgroundColor = ColorAsset.backgroundCell.color
        }
    }
}
