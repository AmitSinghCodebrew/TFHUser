//
//  MedicalHistoryVC.swift
//  RoyoConsultantVendor
//
//  Created by Sandeep Kumar on 13/05/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit
import SZTextView

class MedicalHistoryVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(MedicalHistoryHeaderView.identfier)
            tableView.registerXIBForHeaderFooter(MedicalHistoryFooterView.identfier)
        }
    }

    private var dataSource: TableDataSource<MedicalHistoryHeaderFooterProvider, MedicalHistoryProvider, MedicalHistory>?
    public var requestID: Int?
    private var after: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        localizedSetup()
        tableViewInit()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        default:
            break
        }
    }
}

//MARK: VCFuncs
extension MedicalHistoryVC {
    
    private func getHistoryAPI(isRefreshing: Bool? = false) {
        errorView.removeFromSuperview()
        EP_Home.getMedicalHistory(request_id: requestID, after: /isRefreshing ? nil : after).request { [weak self] (response) in
            
            let newDoctors = (response as? MedicalHistoryData)?.doctors
            self?.after = (response as? MedicalHistoryData)?.after
            let newItems = MedicalHistoryHeaderFooterProvider.getArray(doctors: newDoctors)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /isRefreshing {
                self?.errorView.removeFromSuperview()
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: newItems), .FullReload)
                /newItems.count == 0 ? self?.showVCPlaceholder(type: .NoMedicalHistory, scrollView: self?.tableView) : ()
            } else {
                let oldItems = self?.dataSource?.getMultipleSectionItems() ?? []
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: oldItems + newItems), .FullReload)
            }
            self?.dataSource?.stopInfiniteLoading(self?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.stopLineAnimation()
        } error: { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            self?.stopLineAnimation()
            if /self?.dataSource?.getMultipleSectionItems().count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func localizedSetup() {
        lblTitle.text = VCLiteral.MEDICAL_HISTORY.localized
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<MedicalHistoryHeaderFooterProvider, MedicalHistoryProvider, MedicalHistory>.init(.MultipleSection(items: MedicalHistoryHeaderFooterProvider.getArray(doctors: [])), tableView, true)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? MedicalHistoryHeaderView)?.item = item
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? MedicalHIstoryDescCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getHistoryAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getHistoryAPI(isRefreshing: false)
            }
        }
        
        dataSource?.refreshProgrammatically()
    }
}
