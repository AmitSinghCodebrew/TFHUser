//
//  PackagesVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class PackagesVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Package>, DefaultCellModel<Package>, Package>?
    private var items: [Package]?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = VCLiteral.CHOOSE_PACKAGE.localized
        tableViewInit()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        popVC()
    }
    
}

//MARK:- VCFuncs
extension PackagesVC {
    private func tableViewInit() {
        
        tableView.contentInset.top = 8
        
        let width = UIScreen.main.bounds.width * 0.35
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<Package>, DefaultCellModel<Package>, Package>.init(.SingleListing(items: items ?? [], identifier: PackageCell.identfier, height: width, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? PackageCell)?.item = item
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in 
            let destVC = Storyboard<PackageDetailPopUpVC>.PopUp.instantiateVC()
            destVC.package = item?.property?.model
            destVC.modalPresentationStyle = .overFullScreen
            destVC.callBack = { (callBackType) in
                switch callBackType {
                case .INVALID_BALANCE:
                    let destVC = Storyboard<AddMoneyVC>.Home.instantiateVC()
                    self?.pushVC(destVC)
                case .DEFAULT:
                    break
                }
            }
            self?.presentVC(destVC)
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getPackagesAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getPackagesAPI()
            }
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getPackagesAPI(isRefreshing: Bool? = false) {
        var endPoint = EP_Home.packages(type: .open, categoyId: nil, listBy: .all, after: /isRefreshing ? nil : after)
        
        #if CloudDoc
        endPoint = EP_Home.subscriptions(after: /isRefreshing ? nil : after)
        #endif
        
        endPoint.request(success: { [weak self] (responseData) in
            let response = (responseData as? PackagesData)
            self?.after = response?.after
            if /isRefreshing {
                #if CloudDoc
                self?.items = response?.plans
                #else
                self?.items = response?.packages
                #endif
            } else {
                #if CloudDoc
                self?.items = (self?.items ?? []) + (response?.plans ?? [])
                #else
                self?.items = (self?.items ?? []) + (response?.packages ?? [])
                #endif
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoPackages, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.items?.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
}
