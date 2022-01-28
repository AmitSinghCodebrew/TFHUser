//
//  TipCommentCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 24/09/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TipCommentCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
    typealias T = TipCellPro
    
    var item: TipCellPro? {
        didSet {
            let comment = item?.property?.model?.comment
            imgView.setImageNuke(comment?.user?.profile_image, placeHolder: #imageLiteral(resourceName: "ic_profile_placeholder"))
            lblName.text = /comment?.user?.name
            lblComment.text = /comment?.comment
            let date = Date.init(fromString: /comment?.created_at, format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"), timeZone: .utc)
            lblTime.text = /date.getChatTimeStamp()
        }
    }
    
    
}
