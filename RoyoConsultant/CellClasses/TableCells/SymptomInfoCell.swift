//
//  SymptomInfoCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 02/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class SymptomInfoCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var lblDesc: UILabel!
    
    typealias T = AppDetailCellModel

    var item: AppDetailCellModel? {
        didSet {
            lblDesc.text = /item?.property?.model?.request?.symptom_details
        }
    }
}
