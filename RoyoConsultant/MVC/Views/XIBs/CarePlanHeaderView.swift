//
//  CarePlanHeaderView.swift
//  NurseLynx
//
//  Created by Sandeep Kumar on 26/04/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class CarePlanHeaderView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    
    typealias T = TierHeaderProvider
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgDownUp: UIImageView!
    
    var didTap: (() -> Void)?
    
    var item: TierHeaderProvider? {
        didSet {
            lblTitle.text = /item?.headerProperty?.model?.title
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        didTap?()
    }
}
