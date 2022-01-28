//
//  VendorDetailBtnCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorDetailBtnCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var lblTItle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPerUnit: UILabel!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var backView: UIView!
    
    var item: Any? {
        didSet {
            let obj = item as? Service
            lblTItle.text = /obj?.service_name?.capitalizingFirstLetter()
            lblPrice.text = /obj?.price?.getFormattedPrice()
            backView.backgroundColor = UIColor.init(hex: /obj?.color_code)
            lblPerUnit.text = /obj?.unit_price?.getServicePerUnit()
        }
    }
}

class TierCollectionCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var item: Any? {
        didSet {
            let obj = (item as? TierHeaderProvider)?.headerProperty?.model
            lblTitle.text = /obj?.title?.components(separatedBy: "=").first
            
            backView.backgroundColor = /obj?.isSelected ? ColorAsset.appTint.color : ColorAsset.btnBackWhite.color
            lblTitle.textColor = /obj?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.appTint.color
        }
    }
}
