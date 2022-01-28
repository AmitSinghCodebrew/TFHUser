//
//  TestimonialCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TestimonialCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblTestimonial: UILabel!
    
    var item: Any? {
        didSet {
            let review = item as? Review
            imgView.setImageNuke(review?.consultant?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /review?.consultant?.name
            lblRating.text = /review?.rating?.roundedString(toPlaces: 2)
            lblTestimonial.text = /review?.comment
        }
    }
}
