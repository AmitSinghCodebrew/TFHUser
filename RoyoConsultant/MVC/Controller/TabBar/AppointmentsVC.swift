//
//  HomeVC_Tab2AppointmentsVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 14/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class AppointmentsVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnWallet: RTLSupportedButton!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Requests>, DefaultCellModel<Requests>, Requests>?
    private var items: [Requests]?
    private var after: String?
    private var requestStatus: RequestStatus = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
        #if HomeDoctorKhalid
        lblBalance.isHidden = true
        btnWallet.isHidden = true
        lblBalance.text = ""
        btnStatus.isHidden = false
        btnStatus.setTitle(requestStatus.title.localized, for: .normal)
        btnStatus.semanticContentAttribute = L102Language.isRTL ? .forceLeftToRight : .forceRightToLeft
        #else
        lblBalance.isHidden = true
        btnStatus.isHidden = true
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserPreference.shared.didAddedOrModifiedBooking {
            dataSource?.refreshProgrammatically()
            UserPreference.shared.didAddedOrModifiedBooking = false
        }
        #if HomeDoctorKhalid
        getWalletBalanceAPI()
        #endif
    }
    
    @IBAction func btnStatusAction(_ sender: UIButton) {
        let statusArray: [RequestStatus] = [.all, .pending, .completed, .canceled]
        let stringArray = statusArray.map({$0.title.localized})
        actionSheet(for: stringArray, title: nil, message: nil) { tappedStatus in
            if let index: Int = stringArray.firstIndex(where: {/$0 == /tappedStatus}) {
                self.requestStatus = statusArray[index]
                self.btnStatus.setTitle(self.requestStatus.title.localized, for: .normal)
                self.dataSource?.refreshProgrammatically()
            }
        }
    }
    
    @IBAction func btnWalletAction(_ sender: UIButton) {
        pushVC(Storyboard<WalletVC>.Home.instantiateVC())
    }
}

//MARK:- VCFuncs
extension AppointmentsVC {
    private func getWalletBalanceAPI() {
        if /UserPreference.shared.data?.token == "" {
            return
        }
        EP_Home.wallet.request(success: { [weak self] (responseData) in
            let walletBalance = (responseData as? WalletBalance)?.balance
            self?.lblBalance.text = walletBalance?.getFormattedPrice()
        }) { (error) in
            
        }
    }
    
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.APPOINTMENTS.localized
    }
    
    public func reloadViaNotification() {
        guard let _ = tableView  else {
            return
        }
        errorView.removeFromSuperview()
        getRequestsAPI(isRefreshing: true)
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.top = 16.0
        
        dataSource = TableDataSource<DefaultHeaderFooterModel<Requests>, DefaultCellModel<Requests>, Requests>.init(.SingleListing(items: items ?? [], identifier: AppointmentCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getRequestsAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getRequestsAPI()
            }
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? AppointmentCell)?.item = item
            (cell as? AppointmentCell)?.didReloadCell = { [weak self] in
                self?.items?[indexPath.row].status = item?.property?.model?.status
                self?.items?[indexPath.row].canCancel = item?.property?.model?.canCancel
                self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .Reload(indexPaths: [indexPath], animation: .automatic))
            }
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            let destVC = Storyboard<ApptDetailVC>.Home.instantiateVC()
            destVC.request = item?.property?.model
            destVC.requestUpdated = { (request) in
                item?.property?.model = request
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            self?.pushVC(destVC)
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getRequestsAPI(isRefreshing: Bool? = false) {
        EP_Home.requests(date: nil, serviceType: .all, after: /isRefreshing ? nil : after, second_oponion: nil, status: requestStatus).request(success: { [weak self] (responseData) in
            let response = responseData as? RequestData
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.requests ?? []
            } else {
                self?.items = (self?.items ?? []) + (response?.requests ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoAppointments, scrollView: self?.tableView) : ()
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
