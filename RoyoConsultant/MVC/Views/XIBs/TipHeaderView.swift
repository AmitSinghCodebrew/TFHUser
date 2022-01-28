//
//  TipHeaderView.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TipHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    
    typealias T = TipSectionPro
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var item: TipSectionPro? {
        didSet {
            lblTitle.text = /item?.headerProperty?.model?.title
        }
    }
    
}
