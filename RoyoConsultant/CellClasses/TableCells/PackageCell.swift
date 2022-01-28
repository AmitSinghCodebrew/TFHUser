//
//  PackageCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class PackageCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Package>
    
    @IBOutlet weak var imgView: UIImageView!
    
    var item: DefaultCellModel<Package>? {
        didSet {
            imgView.setImageNuke(item?.property?.model?.image, placeHolder: nil)
        }
    }
}
