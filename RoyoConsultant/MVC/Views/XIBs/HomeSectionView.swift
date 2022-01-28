//
//  HomeSectionView.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeSectionView: UITableViewHeaderFooterView, ReusableHeaderFooter {
    
    typealias T = HomeSectionProvider
    
    @IBOutlet weak var lblTitleTop: UILabel!
    @IBOutlet weak var lblTitleBottom: UILabel!
    @IBOutlet weak var viewAll: UIButton!
    
    public var isClassesScreen: Bool? = false

    var item: HomeSectionProvider? {
        didSet {
            lblTitleTop.text = /item?.headerProperty?.model?.titleRegular?.localized
            lblTitleBottom.text = /item?.headerProperty?.model?.titleBold?.localized
            viewAll.isHidden = /item?.headerProperty?.model?.isBtnHidden
            viewAll.setTitle(/item?.headerProperty?.model?.btnText?.localized, for: .normal)
        }
    }
    
    @IBAction func btnViewAllAction(_ sender: Any) {
        let destVC = Storyboard<SubCategoryVC>.Home.instantiateVC()
        destVC.navigationType = /isClassesScreen ? .Classes : .Consultation
        UIApplication.topVC()?.pushVC(destVC)
    }
}
