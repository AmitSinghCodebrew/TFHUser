//
//  TransactionCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell, ReusableCell {
    
    typealias T = DefaultCellModel<Payment>
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFromTo: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    var item: DefaultCellModel<Payment>? {
        didSet {
            let obj = item?.property?.model
            lblFromTo.text = /obj?.type?.transactionText.localized
    
            let amount = /obj?.amount?.getFormattedPrice()

            switch obj?.type ?? .all {
            case .deposit, .add_money:
                lblName.text = ""
                lblAmount.text = "+\(amount)"
            case .withdrawal:
                lblName.text = /obj?.from?.name
                lblAmount.text = "-\(amount)"
            case .add_package, .asked_question:
                lblName.text = ""
                lblAmount.text = "-\(amount)"
            case .refund:
                lblName.text = /obj?.from?.name
                lblAmount.text = "+\(amount)"
            case .all:
                lblAmount.text = "+\(amount)"
                lblName.text = /obj?.from?.name
                
            }
            
            let transactionDate = Date.init(fromString: /obj?.created_at, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblDate.text = /transactionDate.toString(DateFormat.custom("MMM d"), isForAPI: false)
            lblTime.text = /transactionDate.toString(DateFormat.custom("hh:mm a"), isForAPI: false)
        }
    }
    
}
