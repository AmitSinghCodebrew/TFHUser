//
//  QuestionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    var item: Any? {
        didSet {
            imgView.backgroundColor = ColorAsset.appTint.color
            let obj = item as? Feed
            imgView.setImageNuke(obj?.image)
            lblTitle.text = /obj?.title
            lblDate.text = VCLiteral.GET_ADVICE.localized
        }
    }
}
