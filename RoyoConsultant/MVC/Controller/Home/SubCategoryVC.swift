//
//  SubCategoryVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import MXParallaxHeader
enum CategoryNavigation {
    case Classes
    case Consultation
    case AskQuestion
    
    var title: String {
        switch self {
        case .Classes, .Consultation:
            return "\(VCLiteral.MEET.localized) \(VCLiteral.WITH_EXPERTS.localized)"
        case .AskQuestion:
            return VCLiteral.SELECT_CATEGORY.localized
        }
    }
}

class SubCategoryVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet var couponsView: UIView!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var dataSource: CollectionDataSource?
    private var couponDataSource: CollectionDataSource?
    private var items: [Category]?
    private var coupons: [Coupon]?
    public var parentCat: Category?
    private var after: String?
    public var navigationType: CategoryNavigation = .Consultation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        collectionViewInit()
        switch navigationType {
        case .Consultation:
            getCouponsAPI()
        case .AskQuestion, .Classes:
            break
        }
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        popVC()
    }
}

//MARK:- VCFuncs
extension SubCategoryVC {
    private func localizedTextSetup() {
        lblTitle.text = parentCat?.name ?? navigationType.title
//        lblNoData.text = String.init(format: VCLiteral.VENDOR_LISTING_NO_DATA.localized, /parentCat?.name?.lowercased())
//        lblNoData.isHidden = true
        pageControl.isHidden = true
    }
    
    private func collectionViewInit() {
        
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        let height = width * 0.585
        collectionVIew.contentInset.top = 16.0
        
        dataSource = CollectionDataSource.init(items, parentCat == nil ? SubCategoryCell.identfier : AppSettings.subCategoryCellID, collectionVIew, CGSize.init(width: width, height: height), UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16), 16, 16, .vertical)
        
        dataSource?.scrollDirection = { [weak self] (direction) in
            if direction == .Down {
                self?.navView.isHidden = true
            }
            self?.navigationBarAnimationHandling(direction: direction)
        }
        
        let imageSize = CGSize.init(width: height - 16, height: height - 16)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? SubCategoryCell)?.imageSize = imageSize
            (cell as? SubCategoryCell)?.item = item
            (cell as? SubCategoryCenterCell)?.item = item
        }
        
        dataSource?.didSelectItem = { [weak self] (indexPath, item) in
            if /(item as? Category)?.is_subcategory {
                let destVC = Storyboard<SubCategoryVC>.Home.instantiateVC()
                destVC.parentCat = item as? Category
                destVC.navigationType = (self?.navigationType)!
                self?.pushVC(destVC)
            } else {
                switch (self?.navigationType)! {
                case .Classes:
                    if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) {
                        let destVC = Storyboard<ClassesVC>.Home.instantiateVC()
                        destVC.category = item as? Category
                        UIApplication.topVC()?.pushVC(destVC)
                    }
                case .Consultation:
                    let destVC = Storyboard<VendorListingVC>.Home.instantiateVC()
                    destVC.category = item as? Category
                    self?.pushVC(destVC)
                case .AskQuestion:
                    let destVC = Storyboard<AskQuestionVC>.Home.instantiateVC()
                    destVC.category = item as? Category
                    self?.pushVC(destVC)
                }
            }
        }
        
        dataSource?.addPullToRefreshVertically({ [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getCategoriesAPI(isRefreshing: true)
        })
        
        dataSource?.addInfiniteScrollVertically = { [weak self] in
            if self?.after != nil {
                self?.getCategoriesAPI(isRefreshing: false)
            }
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func couponsConfig() {
        
        pageControl.isHidden = false
        
        let width = UIScreen.main.bounds.width
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: 120.0), interItemSpacing: 0, lineSpacing: 0, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 16, right: 0))
        
        couponCollectionView.isPagingEnabled = true
        
        pageControl.numberOfPages = /coupons?.count
        pageControl.currentPage = 0
        
        couponDataSource = CollectionDataSource.init(coupons, CouponCell.identfier, couponCollectionView, sizeProvider.cellSize, sizeProvider.edgeInsets, sizeProvider.lineSpacing, sizeProvider.interItemSpacing, .horizontal)
        
        couponDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CouponCell)?.item = item
        }
        
        couponDataSource?.didChangeCurrentIndex = { [weak self] (indexPath) in
            self?.pageControl.currentPage = indexPath.item
        }
        
        collectionVIew.parallaxHeader.view = couponsView
        collectionVIew.parallaxHeader.height = sizeProvider.cellSize.height + sizeProvider.edgeInsets.top + sizeProvider.edgeInsets.bottom
    }
    
    private func getCategoriesAPI(isRefreshing: Bool? = false) {
        playLineAnimation()
        EP_Home.categories(parentId: parentCat == nil ? nil : String(/parentCat?.id), after: /isRefreshing ? nil : after, per_page: 20).request(success: { [weak self] (responseData) in
            let response = responseData as? CategoryData
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.classes_category
            } else {
                self?.items = (self?.items ?? []) + (response?.classes_category ?? [])
            }
//            self?.lblNoData.isHidden = /self?.items?.count != 0
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateData(self?.items)
            self?.stopLineAnimation()
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.collectionVIew, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func getCouponsAPI() {
        EP_Home.coupons(categoryId: String(/parentCat?.id), serviceId: nil).request(success: { [weak self] (responseData) in
            self?.coupons = (responseData as? CouponsData)?.coupons
            if /self?.coupons?.count > 0 {
                self?.couponsConfig()
            }
        }) { (_) in
            
        }
    }
    
    //MARK:- Handling Animation for navigation bar
    private func navigationBarAnimationHandling(direction: ScrollDirection) {
        titleTopConstraint.constant = direction == .Up ? -44 : 0
        UIView.transition(with: lblTitle, duration: 0.2, options: .curveLinear, animations: { [weak self] in
            self?.lblTitle.textAlignment = direction == .Up ? .center : .left
        })
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.lblTitle?.transform = direction == .Up ? CGAffineTransform.init(scaleX: 0.6, y: 0.6) : CGAffineTransform.identity
            self?.view.layoutSubviews()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navView.isHidden = (direction == .Down)
        }
    }
}
