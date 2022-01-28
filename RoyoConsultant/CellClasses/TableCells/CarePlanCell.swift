//
//  CarePlanCell.swift
//  NurseLynx
//
//  Created by Sandeep Kumar on 15/04/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class CarePlanCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var viewToggleNeedSomeHelp: UIView!
    @IBOutlet weak var viewToggleNeedMuchHelp: UIView!
    @IBOutlet weak var lblNeedSomeHelp: UILabel!
    @IBOutlet weak var lblNeedMuchHelp: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    
    typealias T = TierCellProvider
    
    var reloadCell: ((_ _item: TierCellProvider?) -> Void)?
    
    var item: TierCellProvider? {
        didSet {
            lblNeedSomeHelp.text = VCLiteral.NeedSomeHelp.localized
            lblNeedMuchHelp.text = VCLiteral.NeedMuchHelp.localized
            lblPlan.text = /item?.property?.model?.title
            switch item?.property?.model?.type ?? .None {
            case .None:
                viewToggleNeedSomeHelp.isHidden = true
                viewToggleNeedMuchHelp.isHidden = true
            case .NeedSomeHelp:
                viewToggleNeedSomeHelp.isHidden = false
                viewToggleNeedMuchHelp.isHidden = true
            case .NeedMuchHelp:
                viewToggleNeedSomeHelp.isHidden = true
                viewToggleNeedMuchHelp.isHidden = false
            }
        }
    }

    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Need Some Help
            item?.property?.model?.type = (item?.property?.model?.type ?? .None) == .NeedSomeHelp ? .None : .NeedSomeHelp
        case 1: //Need Much Help
            item?.property?.model?.type = (item?.property?.model?.type ?? .None) == .NeedMuchHelp ? .None : .NeedMuchHelp
        default:
            break
        }
        reloadCell?(item)
    }
    
}

class CarePlanCellNew: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var viewToggleNeedSomeHelp: UIView!
    @IBOutlet weak var viewToggleNeedMuchHelp: UIView!
    @IBOutlet weak var lblNeedSomeHelp: UILabel!
    @IBOutlet weak var lblNeedMuchHelp: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    
    typealias T = DefaultCellModel<TierOption>

    var reloadCell: ((_ _item: TierOption?) -> Void)?
    
    var item: DefaultCellModel<TierOption>? {
        didSet {
            lblNeedSomeHelp.text = VCLiteral.NeedSomeHelp.localized
            lblNeedMuchHelp.text = VCLiteral.NeedMuchHelp.localized
            lblPlan.text = /item?.property?.model?.title
            switch item?.property?.model?.type ?? .None {
            case .None:
                viewToggleNeedSomeHelp.isHidden = true
                viewToggleNeedMuchHelp.isHidden = true
            case .NeedSomeHelp:
                viewToggleNeedSomeHelp.isHidden = false
                viewToggleNeedMuchHelp.isHidden = true
            case .NeedMuchHelp:
                viewToggleNeedSomeHelp.isHidden = true
                viewToggleNeedMuchHelp.isHidden = false
            }
        }
    }

    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Need Some Help
            item?.property?.model?.type = (item?.property?.model?.type ?? .None) == .NeedSomeHelp ? .None : .NeedSomeHelp
        case 1: //Need Much Help
            item?.property?.model?.type = (item?.property?.model?.type ?? .None) == .NeedMuchHelp ? .None : .NeedMuchHelp
        default:
            break
        }
        reloadCell?(item?.property?.model)
    }
    
}
