//
//  ChooseDateCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ChooseDateCell: UICollectionViewCell, ReusableCellCollection {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    
    var item: Any? {
        didSet {
            let obj = item as? DateModel
            lblDay.text = /obj?.date?.weekdayToString()
            lblDate.text = /obj?.date?.toString(DateFormat.custom(UserPreference.shared.dateFormat), isForAPI: false)
            viewBottom.isHidden = !(/obj?.isSelected)
        }
    }
}
