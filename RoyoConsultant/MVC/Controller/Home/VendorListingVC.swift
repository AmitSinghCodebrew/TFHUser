//
//  VendorListingVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorListingVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionFilters: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var collectionCoupons: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    public var category: Category?
    public var serviceType: ServiceType?
    public var isSecondOpinion = false
    
    private var couponDataSource: CollectionDataSource?
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Vendor>, DefaultCellModel<Vendor>, Vendor>?
    private var collectionDataSource: CollectionDataSource?
    private var items: [Vendor]?
    private var page: Int = 1
    private var filters: [Filter]?
    private var services: [Service]?
    private var serviceId: Int?
    private var searchText: String?
    private var coupons: [Coupon]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
        collectionFiltersInit()
        if let _ = category {
            getFiltersAPI()
            getServicesAPI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.getCouponsAPI()
            }
        }
        //Remove Login Stroyboard screens if navigated through short login while booking
        var navigationStackVCs = navigationController?.viewControllers ?? []
        navigationStackVCs.removeAll(where: {$0.isKind(of: ShortLoginVC.self) || $0.isKind(of: VerificationVC.self)})
        navigationController?.setViewControllers(navigationStackVCs, animated: false)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Filter
            let destVC = Storyboard<FilterPopUpVC>.PopUp.instantiateVC()
            destVC.modalPresentationStyle = .overFullScreen
            destVC.filters = Filter.generateNewReferenceArray(filters: filters ?? [])
            destVC.filtersApplied = { [weak self] (selectedFilters, isCleared) in
                self?.page = 1
                self?.filters = selectedFilters
                self?.setColorsForBtnFilter(isSelected: !(/isCleared))
                self?.playLineAnimation()
                self?.getVendorsListAPI(isRefreshing: true)
            }
            presentVC(destVC)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension VendorListingVC {
    private func localizedTextSetup() {
        lblTitle.text = category?.name ?? /serviceType?.title.localized
        tfSearch.placeholder = String.init(format: VCLiteral.SEARCH_FOR.localized, category?.name ?? /serviceType?.title.localized)
        collectionFilters.isHidden = true
        btnFilter.isHidden = true
        collectionCoupons.isHidden = true
        setColorsForBtnFilter(isSelected: false)
        tfSearch.addTarget(self, action: #selector(searchTextDidChanged(tf:)), for: .editingChanged)
        tfSearch.addTarget(self, action: #selector(handleSearch), for: .editingDidEndOnExit)
        pageControl.isHidden = true
    }
    
    @objc private func searchTextDidChanged(tf: UITextField) { //Called in sync as text changed in Search textfield
        searchText = tf.text
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleSearch), object: nil)
        perform(#selector(handleSearch), with: nil, afterDelay: 0.5)
    }
    
    @objc private func handleSearch() { //with delay in typing speed
        page = 1
        getVendorsListAPI(isRefreshing: true)
    }
    
    private func collectionFiltersInit() {
        collectionDataSource = CollectionDataSource.init(services, VendorFilterCell.identfier, collectionFilters, CGSize.init(width: 88, height: 36), UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16), 16, 0, .horizontal)
        
        collectionDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorFilterCell)?.item = item
        }
        
        collectionDataSource?.didSelectItem = { [weak self] (indexPath, item) in
            self?.services?.forEach({$0.isSelected = false})
            self?.services?[indexPath.item].isSelected = true
            self?.serviceId = (item as? Service)?.service_id
            self?.errorView.removeFromSuperview()
            self?.page = 1
            self?.collectionDataSource?.updateData(self?.services)
            self?.playLineAnimation()
            self?.getVendorsListAPI(isRefreshing: true)
        }
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 12
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<Vendor>, DefaultCellModel<Vendor>, Vendor>.init(.SingleListing(items: items ?? [], identifier: VendorCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.page = 1
            self?.errorView.removeFromSuperview()
            self?.tfSearch.text = nil
            self?.getVendorsListAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            self?.getVendorsListAPI()
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            let destVC = Storyboard<VendorDetailVC>.Home.instantiateVC()
            destVC.vendor = item?.property?.model?.vendor_data
            destVC.isSecondOpinion = /self?.isSecondOpinion
            destVC.serviceType = self?.serviceType
            self?.pushVC(destVC)
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getVendorsListAPI(isRefreshing: Bool? = false) {
        collectionFilters.isUserInteractionEnabled = false
        btnFilter.isUserInteractionEnabled = false
        
        errorView.removeFromSuperview()
        
        let filterOptionsSelected = filters?.compactMap({$0.options}).flatMap({$0}).filter({/$0.isSelected}) ?? []
        let selectedFilterIds = filterOptionsSelected.compactMap({String(/$0.id)})
        let idsToSend = selectedFilterIds.joined(separator: ",")
        
        EP_Home.vendorList(categoryId: category?.id, filterOptionIds: selectedFilterIds.count == 0 ? nil : idsToSend, service_id: serviceId, search: searchText, page: page, serviceType: serviceType, after: /isRefreshing ? nil : self.items?.last?.id).request(success: { [weak self] (responseData) in
            let response = responseData as? VendorData
            self?.page = /self?.page + 1
            if /isRefreshing {
                self?.items = response?.vendors
            } else {
                self?.items = (self?.items ?? []) + (response?.vendors ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoVendors(categoryName: self?.category?.name?.capitalizingFirstLetter() ?? /self?.serviceType?.title.localized), scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(/response?.next_page_url == "" ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
            self?.stopLineAnimation()
            self?.collectionFilters.isUserInteractionEnabled = true
            self?.btnFilter.isUserInteractionEnabled = true
        }) { [weak self] (error) in
            self?.collectionFilters.isUserInteractionEnabled = true
            self?.btnFilter.isUserInteractionEnabled = true
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func getFiltersAPI() {
        EP_Home.getFilters(categoryId: String(/category?.id)).request(success: { [weak self] (responseData) in
            self?.filters = (responseData as? FilterData)?.filters
            UIView.animate(withDuration: 0.3) {
                self?.btnFilter.isHidden = /self?.filters?.count == 0
            }
        }) { (error) in
            
        }
    }
    
    private func getServicesAPI() {
        EP_Home.services(categoryId: String(/category?.id)).request(success: { [weak self] (responseData) in
            self?.services = (responseData as? ServicesData)?.services
            self?.services?.insert(Service.init(VCLiteral.ALL_SMALL.localized), at: 0)
            self?.collectionFilters.contentInset.right = 16 * (CGFloat(/self?.services?.count) - 1)
            self?.collectionDataSource?.updateData(self?.services)
            UIView.animate(withDuration: 0.3) {
                self?.collectionFilters.isHidden = /self?.services?.count <= 1
            }
        }) { (error) in
            
        }
    }
    
    private func getCouponsAPI() {
        EP_Home.coupons(categoryId: String(/category?.id), serviceId: nil).request(success: { [weak self] (responseData) in
            self?.coupons = (responseData as? CouponsData)?.coupons
            if /self?.coupons?.count > 0 {
                self?.couponsConfig()
            }
        }) { (_) in
            
        }
    }
    
    private func couponsConfig() {
        collectionCoupons.isHidden = false
        pageControl.isHidden = false
        pageControl.numberOfPages = /coupons?.count
        pageControl.currentPage = 0
        
        let width = UIScreen.main.bounds.width
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: 120.0), interItemSpacing: 0, lineSpacing: 0, edgeInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        
        collectionCoupons.isPagingEnabled = true
        
        couponDataSource = CollectionDataSource.init(coupons, CouponCell.identfier, collectionCoupons, sizeProvider.cellSize, sizeProvider.edgeInsets, sizeProvider.lineSpacing, sizeProvider.interItemSpacing, .horizontal)
        
        couponDataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CouponCell)?.item = item
        }
        
        couponDataSource?.didChangeCurrentIndex = { [weak self] (indexPath) in
            self?.pageControl.currentPage = indexPath.item
        }
    }
    
    private func setColorsForBtnFilter(isSelected: Bool) {
        btnFilter.borderColor = isSelected ? ColorAsset.appTint.color : ColorAsset.btnBorder.color
        btnFilter.backgroundColor = isSelected ? ColorAsset.appTint.color : ColorAsset.backgroundColor.color
        btnFilter.tintColor = isSelected ? ColorAsset.txtWhite.color : ColorAsset.txtExtraLight.color
    }
}
