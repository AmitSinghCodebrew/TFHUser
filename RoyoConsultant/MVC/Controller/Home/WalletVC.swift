//
//  WalletVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class WalletVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAvailBalanceTitle: UILabel!
    @IBOutlet weak var lblAvailBalanceValue: UILabel!
    @IBOutlet weak var lblTransactionHistory: UILabel!
    @IBOutlet weak var btnAddMoney: SKButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<Payment>, DefaultCellModel<Payment>, Payment>?
    private var items = [Payment]()
    private var walletBalance: Double?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getWalletBalanceAPI()
        getTransactionHistoryAPI(isRefreshing: true)
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 1: //Add Money
            pushVC(Storyboard<AddMoneyVC>.Home.instantiateVC())
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension WalletVC {
    
    public func reloadViaNotification() {
        guard let _ = tableView  else {
            return
        }
        errorView.removeFromSuperview()
        getTransactionHistoryAPI(isRefreshing: true)
        getWalletBalanceAPI()
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<Payment>, DefaultCellModel<Payment>, Payment>.init(.SingleListing(items: items, identifier: TransactionCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? TransactionCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getTransactionHistoryAPI(isRefreshing: true)
            self?.getWalletBalanceAPI()
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getTransactionHistoryAPI()
            }
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.WALLET.localized
        lblAvailBalanceTitle.text = VCLiteral.AVAILABLE_BALANCE.localized
        lblAvailBalanceValue.text = /(0.0).getFormattedPrice()
        lblTransactionHistory.text = VCLiteral.TRANSACTION_HISTORY.localized
        btnAddMoney.setTitle(VCLiteral.ADD_MONEY.localized, for: .normal)
    }
    
    private func getTransactionHistoryAPI(isRefreshing: Bool? = false) {
        EP_Home.transactionHistory(transactionType: .all, after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            self?.errorView.removeFromSuperview()
            let response = responseData as? TransactionData
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.payments ?? []
            } else {
                self?.items = (self?.items ?? []) + (response?.payments ?? [])
            }
            /self?.items.count == 0 ? self?.showVCPlaceholder(type: .NoWallet, scrollView: self?.tableView) : ()
            self?.dataSource?.stopInfiniteLoading(response?.after == nil ? .NoContentAnyMore : .FinishLoading)
            self?.dataSource?.updateAndReload(for: .SingleListing(items: self?.items ?? []), .FullReload)
        }) { [weak self] (error) in
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
            if /self?.items.count == 0 {
                self?.showErrorView(error: /error, scrollView: self?.tableView, tapped: {
                    self?.errorView.removeFromSuperview()
                    self?.dataSource?.refreshProgrammatically()
                })
            }
        }
    }
    
    private func getWalletBalanceAPI() {
        EP_Home.wallet.request(success: { [weak self] (responseData) in
            self?.walletBalance = (responseData as? WalletBalance)?.balance
            self?.lblAvailBalanceValue.text = /self?.walletBalance?.getFormattedPrice()
        }) { (error) in
            
        }
    }
}
