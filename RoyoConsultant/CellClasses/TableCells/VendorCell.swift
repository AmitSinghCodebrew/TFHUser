//
//  VendorCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Vendor>
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    var item: DefaultCellModel<Vendor>? {
        didSet {
            let obj = item?.property?.model?.vendor_data
            imgView.setImageNuke(/obj?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = "\(/obj?.profile?.title) \(/obj?.name)".trimmingCharacters(in: .whitespaces)
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
            let experience = "\(Date().year() - /Date.init(fromString: /obj?.profile?.working_since, format: DateFormat.custom("yyyy-MM-dd")).year())".experience
            stringsArray.append(experience)
            
//            if /item?.property?.model?.distance != 0.0 {
                stringsArray.append("Distance: \(String(/item?.property?.model?.distance))Km")
//            }
            #if Heal
            lblDesc.text = /obj?.categoryData?.name
            #else
            lblDesc.text = stringsArray.joined(separator: "\n")
            #endif
            
            lblRating.text = "\(/obj?.totalRating) · \(/obj?.reviewCount) \(/obj?.reviewCount == 1 ? VCLiteral.REVIEW.localized : VCLiteral.REVIEWS.localized)"
        }
    }
}
