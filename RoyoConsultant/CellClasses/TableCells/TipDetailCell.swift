//
//  TipDetailCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TipDetailCell: UITableViewCell, ReusableCell {
        
    @IBOutlet weak var lblDesc: UILabel!
    typealias T = TipCellPro
    
    var item: TipCellPro? {
        didSet {
            lblDesc.text = /item?.property?.model?.tip?.description
        }
    }
    
}
