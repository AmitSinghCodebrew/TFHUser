//
//  VendorExtraInfoCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/10/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorExtraInfoCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider

    @IBOutlet weak var lblText: UILabel!

    var item: VD_Cell_Provider? {
        didSet {
            let obj = item?.property?.model?.vendor
            
            var stringsArray = [String]()
            
            obj?.custom_fields?.forEach({ (field) in
                stringsArray.append("\(/field.field_name): \(/field.field_value)")
            })
            
            obj?.master_preferences?.forEach({ (filter) in
                let options = filter.options?.filter({/$0.isSelected})
                if /options?.count != 0 {
                    let optionsString = /options?.map({/$0.option_name}).joined(separator: ", ")
                    stringsArray.append("\(/filter.preference_name): \(optionsString)")
                }
            })
            
            lblText.text = stringsArray.joined(separator: "\n")
        }
    }
}
