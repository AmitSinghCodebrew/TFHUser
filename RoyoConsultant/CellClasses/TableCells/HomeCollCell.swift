//
//  HomeCollCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeCollCell: UITableViewCell, ReusableCell {
    
    typealias T = HomeCellProvider
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    public var isClassesScreen: Bool? = false
    private var collectionDataSource: CollectionDataSource?
    lazy var errorView: ErrorView = {
        let eView: ErrorView = .fromNib()
        return eView
    }()
    
    var item: HomeCellProvider? {
        didSet {
            let obj = item?.property?.model
            
            if /obj?.identifier == BlogCell.identfier {
                if /obj?.collectionItems?.count == 0 {
                    if self.contentView.subviews.contains(errorView) {
                        errorView.showNoDataWithImage(type: .NoArticles)
                    } else {
                        errorView.frame = self.bounds
                        self.addSubview(errorView)
                        errorView.showNoDataWithImage(type: .NoArticles)
                    }
                } else {
                    errorView.removeFromSuperview()
                }
            } else {
                errorView.removeFromSuperview()
            }
            
            collectionView.isPagingEnabled = /obj?.identifier == BannerCell.identfier
            pageControl.isHidden = !(/obj?.identifier == BannerCell.identfier)
            pageControl.isUserInteractionEnabled = false
            pageControl.numberOfPages = /obj?.collectionItems?.count
            pageControl.currentPage = 0
            pageControl.subviews.forEach {
                $0.transform = CGAffineTransform.init(scaleX: 2, y: 1)
            }
            
            collectionDataSource = CollectionDataSource.init(obj?.collectionItems, /obj?.identifier, collectionView, obj?.collProvider?.cellSize, obj?.collProvider?.edgeInsets, obj?.collProvider?.lineSpacing, obj?.collProvider?.interItemSpacing, obj?.scrollDirection ?? .vertical)
            
            collectionDataSource?.configureCell = { (cell, item, indexPath) in
                (cell as? BannerCell)?.item = item
                (cell as? BlogCell)?.item = item
                (cell as? ServiceTypeCell)?.item = item
                (cell as? HealthToolCell)?.item = item
                (cell as? QuestionCell)?.item = item
                (cell as? TestimonialCell)?.item = item
            }
            
            collectionDataSource?.didSelectItem = { [weak self] (indexPath, item) in
                switch /obj?.identifier {
                case BannerCell.identfier:
                    self?.handleBannerTapped(item as? Banner)
                case BlogCell.identfier, QuestionCell.identfier:
                    let destVC = Storyboard<BlogDetailVC>.Home.instantiateVC()
                    destVC.feed = item as? Feed
                    destVC.didUpdated = { (feed) in
                        self?.item?.property?.model?.collectionItems?[indexPath.row] = feed!
                        self?.collectionDataSource?.updateData(self?.item?.property?.model?.collectionItems)
                    }
                    UIApplication.topVC()?.pushVC(destVC)
                case ServiceTypeCell.identfier:
                    switch (item as? CustomService)?.type ?? .unknown {
                    case .consult_online, .clinic_visit:
                        let destVC = Storyboard<VendorListingVC>.Home.instantiateVC()
                        destVC.serviceType = (item as? CustomService)?.type
                        UIApplication.topVC()?.pushVC(destVC)
                    case .home_visit:
                        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: false) {
                            let destVC = Storyboard<VendorListingVC>.Home.instantiateVC()
                            destVC.serviceType = (item as? CustomService)?.type
                            UIApplication.topVC()?.pushVC(destVC)
                        } else {
                            let destVC = Storyboard<ShortLoginVC>.LoginSignUp.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        }
                    case .tipOfTheDay:
                        let destVC = Storyboard<TipOfTheDayVC>.Home.instantiateVC()
                        destVC.tip = (item as? CustomService)?.tip
                        UIApplication.topVC()?.pushVC(destVC)
                    case .free_expert_advice:
                        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
                            let destVC = Storyboard<MyQuestionsVC>.Home.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        }
                    case .online_programs:
                        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
                            let destVC = Storyboard<ClassesVC>.Home.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        }
                    case .emergency:
                        break
                    default:
                        break
                    }
                case HealthToolCell.identfier:
                    if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
                        switch (item as? HealthTool)?.title ?? .HEALTH_TOOL_01_TITLE {
                        case .HEALTH_TOOL_01_TITLE: //BMI
                            let destVC = Storyboard<BMI_CalVC>.Home.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        case .HEALTH_TOOL_02_TITLE: //Water Intake
                            let destVC = Storyboard<WaterIntakeCalVC>.Home.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        case .HEALTH_TOOL_03_TITLE: //Protien Intake
                            let destVC = Storyboard<ProtienIntakeVC>.Home.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        case .HEALTH_TOOL_04_TITLE: //Pregnancy
                            let destVC = Storyboard<PregnancyCalculatorVC>.Home.instantiateVC()
                            UIApplication.topVC()?.pushVC(destVC)
                        default:
                            break
                        }
                    }
                case TestimonialCell.identfier:
                    break
                default:
                    break
                }
            }
            
            collectionDataSource?.didChangeCurrentIndex = { [weak self] (indexPath) in
                self?.pageControl.currentPage = indexPath.item
            }
        }
    }
    
    private func handleBannerTapped(_ obj: Banner?) {
        switch obj?.banner_type ?? .category {
        case .classs:
            break
        case .category:
            if /obj?.category?.is_subcategory {
                let destVC = Storyboard<SubCategoryVC>.Home.instantiateVC()
                destVC.parentCat = obj?.category
                UIApplication.topVC()?.pushVC(destVC)
            } else {
                let destVC = Storyboard<VendorListingVC>.Home.instantiateVC()
                destVC.category = obj?.category
                UIApplication.topVC()?.pushVC(destVC)
            }
        case .service_provider:
            let destVC = Storyboard<VendorDetailVC>.Home.instantiateVC()
            destVC.vendor = obj?.service_provider
            UIApplication.topVC()?.pushVC(destVC)
        }
    }
}
