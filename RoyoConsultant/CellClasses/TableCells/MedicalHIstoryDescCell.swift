//
//  MedicalHIstoryDescCell.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 14/05/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class MedicalHIstoryDescCell: UITableViewCell, ReusableCell {
    
    typealias T = MedicalHistoryProvider
    
    @IBOutlet weak var lblApptDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    

    var item: MedicalHistoryProvider? {
        didSet {
            let utcDate = Date(fromString: /item?.property?.model?.request?.booking_date, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblApptDate.text = "Appointment Date: \(utcDate.toString(DateFormat.custom(UserPreference.shared.dateFormat), timeZone: .local, isForAPI: false))"
            lblDesc.text = /item?.property?.model?.comment
        }
    }
}
