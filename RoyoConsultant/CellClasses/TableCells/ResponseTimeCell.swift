//
//  ResponseTimeCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ResponseTimeCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    typealias T = DefaultCellModel<Package>
    
    var item: DefaultCellModel<Package>? {
        didSet {
            lblTitle.text = /item?.property?.model?.title
            lblDesc.text = /item?.property?.model?.description
            lblPrice.text =  /item?.property?.model?.price?.getFormattedPrice()
            backView.backgroundColor = UIColor.init(hex: /item?.property?.model?.color_code?.lowercased())
            imgView.setImageNuke(item?.property?.model?.image_icon)
        }
    }

}
