//
//  SideMenuCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<ProfileItem>

    @IBOutlet weak var btnImage: RTLSupportedButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var item: DefaultCellModel<ProfileItem>? {
        didSet {
            btnImage.setRTLsupported(image: item?.property?.model?.image ?? UIImage())
            if let page = item?.property?.model?.page {
                lblTitle.text = /page.title
            } else {
                lblTitle.text = /item?.property?.model?.title?.localized
            }
        }
    }
    
}
