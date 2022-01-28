//
//  InsuranceDetailCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 23/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class InsuranceDetailCell: UITableViewCell, ReusableCell {

    typealias T = DefaultCellModel<InsuranceInfo>
    
    @IBOutlet weak var lblInsuranceTitle: UILabel!
    @IBOutlet weak var lblInsuranceExpiry: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnDoc: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var didTapDelete: (() -> Void)?
    
    var item: DefaultCellModel<InsuranceInfo>? {
        didSet {
            let obj = item?.property?.model
            btnDoc?.isHidden = !(obj?.type == .pdf)
            imgView.setImageNuke(obj?.image)
            lblInsuranceTitle.text = String.init(format: VCLiteral.INSURANCE_NUMBER_VALUE.localized, /obj?.insuranceNumber)
            let date = Date.init(fromString: /obj?.expiry, format: DateFormat.custom("yyyy-MM-dd")).toString(DateFormat.custom("MMM d, yyyy"), isForAPI: false)
            lblInsuranceExpiry.text = String.init(format: VCLiteral.INSURANCE_EXPIRY_VALUE.localized, date)
            btnDelete.setTitle(VCLiteral.DELETE.localized, for: .normal)
        }
    }
    
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        didTapDelete?()
    }
}
