//
//  HomeHeaderCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var banckView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    
    var item: Any? {
        didSet {
            let obj = item as? Banner
            imgView.setImageNuke(/obj?.image_mobile)
            banckView.backgroundColor = ColorAsset.bannerBack.color
        }
    }
}
