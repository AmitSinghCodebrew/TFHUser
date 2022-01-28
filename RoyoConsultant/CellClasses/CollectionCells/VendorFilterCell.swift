//
//  VendorFilterCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorFilterCell: UICollectionViewCell, ReusableCellCollection {
    
    @IBOutlet weak var backView: GradientView!
    @IBOutlet weak var lblText: UILabel!
    
    var item: Any? {
        didSet {
            let obj = item as? Service
            lblText.text = /obj?.name?.capitalizingFirstLetter()
            backView.borderWidth = 1.0
            backView.borderColor = /obj?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.btnBorder.color
            gradientSetup(isSelected: /obj?.isSelected)
            backView.backgroundColor = /obj?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.backgroundCell.color
            lblText.textColor = /obj?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtExtraLight.color
        }
    }
    
    var glass: WaterGlass? {
        didSet {
            if /glass?.qty >= 1000 {
                let valueInLitres = (Double(/glass?.qty) / 1000).roundedString(toPlaces: 2)
                lblText.text = String(format: VCLiteral.LITRE.localized, valueInLitres)
            } else {
                lblText.text = String(format: VCLiteral.MILLI_LITRE.localized, String(/glass?.qty))
            }
            backView.borderWidth = 1.0
            backView.borderColor = /glass?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.btnBorder.color
            gradientSetup(isSelected: /glass?.isSelected)
            backView.backgroundColor = /glass?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.backgroundCell.color
            lblText.textColor = /glass?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtExtraLight.color
        }
    }
    
    var protein: WaterGlass? {
        didSet {
            lblText.text = String(format: VCLiteral.PROTIEN_GMS.localized, String(/protein?.qty))
            backView.borderWidth = 1.0
            backView.borderColor = /protein?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.btnBorder.color
            gradientSetup(isSelected: /protein?.isSelected)
            backView.backgroundColor = /protein?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.backgroundCell.color
            lblText.textColor = /protein?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtExtraLight.color
        }
    }
    
    var symptom: Symptom? {
        didSet {
            lblText.text = /symptom?.name
            backView.borderWidth = 1.0
            backView.borderColor = /symptom?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.txtTheme.color
            backView.backgroundColor = /symptom?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.backgroundCell.color
            gradientSetup(isSelected: /symptom?.isSelected)
            lblText.textColor = /symptom?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtTheme.color
        }
    }
    
    var relation: FamilyMemberType? {
        didSet {
            lblText.text = /relation?.title?.localized
            backView.borderWidth = 1.0
            backView.borderColor = /relation?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.btnBorder.color
            backView.backgroundColor = /relation?.isSelected ? ColorAsset.txtTheme.color : ColorAsset.backgroundCell.color
            gradientSetup(isSelected: /relation?.isSelected)
            lblText.textColor = /relation?.isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtExtraLight.color
        }
    }
    
    func gradientSetup(isSelected: Bool) {
        if UserPreference.shared.isGradientViews == false {
            return
        }
        backView.isGradienHidden(isSelected: isSelected)

    }
}
