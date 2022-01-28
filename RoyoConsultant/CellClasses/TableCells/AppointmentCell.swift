//
//  AppointmentCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Requests>
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRequestType: UILabel!
    @IBOutlet weak var imgVIew: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblViewDetail: UILabel!
    
    var didReloadCell: (() -> Void)?
    
    var item: DefaultCellModel<Requests>? {
        didSet {
            let obj = item?.property?.model
            lblName.text = "\(/obj?.to_user?.profile?.title) \(/obj?.to_user?.name)"
            lblRequestType.text = (/obj?.service_type).uppercased()
            lblStatus.text = /obj?.status?.title.localized
            lblStatus.textColor = obj?.status?.linkedColor.color
            imgVIew.setImageNuke(/obj?.to_user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            let utcDate = Date(fromString: /obj?.bookingDateUTC, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblDate.text = utcDate.toString(DateFormat.custom("\(UserPreference.shared.dateFormat) · hh:mm a"), timeZone: .local, isForAPI: false)
            lblPrice.text = /obj?.price?.getDoubleValue?.getFormattedPrice()
            lblViewDetail.text = VCLiteral.VIEW_DETAIL.localized
        }
    }
}
