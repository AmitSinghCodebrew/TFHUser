//
//  MyQuestionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class MyQuestionCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Question>
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewPrice: UIView!

    @IBOutlet weak var lblTitle: UILabel!
    
    var item: DefaultCellModel<Question>? {
        didSet {
            lblTitle.text = /item?.property?.model?.title
            lblPrice.text = /item?.property?.model?.amount?.getFormattedPrice()
            viewPrice.isHidden = /item?.property?.model?.amount == 0.0
        }
    }
}
