//
//  ApptDetailCarePlanCell.swift
//  NurseLynx
//
//  Created by Sandeep Kumar on 19/04/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class ApptDetailCarePlanCell: UITableViewCell, ReusableCell {
        
    typealias T = AppDetailCellModel
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnTick: UIButton!
    
    var item: AppDetailCellModel? {
        didSet {
            lblText.text = "\(/item?.property?.model?.tierOption?.title) (\(/item?.property?.model?.tierOption?.type?.localized))"
            btnTick.isHidden = !(item?.property?.model?.tierOption?.status == .completed)
        }
    }
}
