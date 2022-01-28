//
//  Category3StackCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 27/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class Category3StackCell: UITableViewCell, ReusableCell {
    
    typealias T = HomeCellProvider
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var imgViewLeft1: UIImageView!
    @IBOutlet weak var imgViewLeft2: UIImageView!
    @IBOutlet weak var imgViewLeft3: UIImageView!
    @IBOutlet weak var leadingText1: NSLayoutConstraint!
    @IBOutlet weak var trailingText1: NSLayoutConstraint!
    @IBOutlet weak var leadingTExt2: NSLayoutConstraint!
    @IBOutlet weak var trailingText2: NSLayoutConstraint!
    @IBOutlet weak var leadingText3: NSLayoutConstraint!
    @IBOutlet weak var trailingText3: NSLayoutConstraint!
    
    public var isClassesScreen: Bool? = false
    
    var item: HomeCellProvider? {
        didSet {
            
            view3.isHidden = !(/item?.property?.model?.collectionItems?.count == 3)
            
            [lblTitle1, lblTitle2, lblTitle3].forEach({$0?.textColor = AppSettings.mainCategoryTextColor })
            
            for (index, category) in (item?.property?.model?.collectionItems ?? []).enumerated() {
                let obj = category as? Category
                let height = (/item?.property?.model?.collProvider?.cellSize.height - 16) - 16
                switch index {
                case 0:
                    lblTitle1.text = /obj?.name
                    view1.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
                    view1.tag = 0
                    if AppSettings.categoryImageAlign == .Left {
                        imgViewLeft1.setCategoryImage(imageOrURL: /obj?.image, size: CGSize.init(width: height, height: height), contentMode: .bottomLeft)
                        imgView1.isHidden = true
                        lblTitle1.textAlignment = .right
                        leadingText1.constant = 48
                        trailingText1.constant = 16
                    } else {
                        lblTitle1.textAlignment = L102Language.isRTL ? .right : .left
                        imgView1.setCategoryImage(imageOrURL: /obj?.image, size: CGSize.init(width: height, height: height), contentMode: L102Language.isRTL ? .bottomLeft : .bottomRight)
                        imgViewLeft1.isHidden = true
                        leadingText1.constant = 16
                        trailingText1.constant = 48
                    }
                case 1:
                    lblTitle2.text = /(category as? Category)?.name
                    view2.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
                    view2.tag = 1
                    if AppSettings.categoryImageAlign == .Left {
                        imgViewLeft2.setCategoryImage(imageOrURL: /obj?.image, size: CGSize.init(width: height, height: height), contentMode: .bottomLeft)
                        imgView2.isHidden = true
                        lblTitle2.textAlignment = .right
                        leadingTExt2.constant = 48
                        trailingText2.constant = 16
                    } else {
                        lblTitle2.textAlignment = L102Language.isRTL ? .right : .left
                        imgView2.setCategoryImage(imageOrURL: /obj?.image, size: CGSize.init(width: height, height: height), contentMode: L102Language.isRTL ? .bottomLeft : .bottomRight)
                        imgViewLeft2.isHidden = true
                        leadingTExt2.constant = 16
                        trailingText2.constant = 48
                    }
                case 2:
                    lblTitle3.text = /(category as? Category)?.name
                    view3.backgroundColor = UIColor.init(hex: /obj?.color_code?.lowercased())
                    view3.tag = 2
                    if AppSettings.categoryImageAlign == .Left {
                        imgViewLeft3.setCategoryImage(imageOrURL: /obj?.image, size: CGSize.init(width: height, height: height), contentMode: .bottomLeft)
                        imgView3.isHidden = true
                        lblTitle3.textAlignment = .right
                        leadingText3.constant = 48
                        trailingText3.constant = 16
                    } else {
                        lblTitle3.textAlignment = L102Language.isRTL ? .right : .left
                        imgView3.setCategoryImage(imageOrURL: /obj?.image, size: CGSize.init(width: height, height: height), contentMode: L102Language.isRTL ? .bottomLeft : .bottomRight)
                        imgViewLeft3.isHidden = true
                        leadingText3.constant = 16
                        trailingText3.constant = 48
                    }
                default:
                    break
                }
                
            }
            
            view1.isUserInteractionEnabled = true
            view2.isUserInteractionEnabled = true
            view3.isUserInteractionEnabled = true
            
            view1.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(gesture:))))
            view2.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(gesture:))))
            view3.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(viewTapped(gesture:))))
        }
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        guard let category = item?.property?.model?.collectionItems?[/gesture.view?.tag] as? Category else {
            return
        }
        handleCategoryTapped(category)
    }
    
    private func handleCategoryTapped(_ obj: Category?) {
        if /obj?.is_subcategory {
            let destVC = Storyboard<SubCategoryVC>.Home.instantiateVC()
            destVC.parentCat = obj
            destVC.navigationType = /isClassesScreen ? .Classes : .Consultation
            UIApplication.topVC()?.pushVC(destVC)
        } else {
            
            #if NurseLynx
            let destVC = Storyboard<ServicePopupVC>.PopUp.instantiateVC()
            destVC.category = obj
            destVC.didSelected = {(service) in
                let vc = Storyboard<EnterDateTimeVC>.Other.instantiateVC()
                vc.category = obj
                vc.service = service
                UIApplication.topVC()?.pushVC(vc)
            }
            UIApplication.topVC()?.presentVC(destVC)
            
            #else
            
            if /isClassesScreen {
                if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
                    let destVC = Storyboard<ClassesVC>.Home.instantiateVC()
                    destVC.category = obj
                    UIApplication.topVC()?.pushVC(destVC)
                }
                return
            } else {
                let destVC = Storyboard<VendorListingVC>.Home.instantiateVC()
                destVC.category = obj
                UIApplication.topVC()?.pushVC(destVC)
            }
            #endif
        }
    }
}
