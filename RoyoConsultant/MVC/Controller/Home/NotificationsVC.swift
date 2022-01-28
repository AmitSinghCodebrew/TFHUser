//
//  NotificationsVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 26/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: TableDataSource<DefaultHeaderFooterModel<NotificationModel>, DefaultCellModel<NotificationModel>, NotificationModel>?
    private var items: [NotificationModel]?
    private var after: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
    
}

//MARK:- VCFuncs
extension NotificationsVC {
    private func localizedTextSetup() {
        lblTitle.text = VCLiteral.NOTIFICATIONS.localized
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<DefaultHeaderFooterModel<NotificationModel>, DefaultCellModel<NotificationModel>, NotificationModel>.init(.SingleListing(items: items ?? [], identifier: NotificationCell.identfier, height: UITableView.automaticDimension, leadingSwipe: nil, trailingSwipe: nil), tableView, true)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? NotificationCell)?.item = item
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.errorView.removeFromSuperview()
            self?.getNotificationsAPI(isRefreshing: true)
        }
        
        dataSource?.addInfiniteScrolling = { [weak self] in
            if self?.after != nil {
                self?.getNotificationsAPI()
            }
        }
        
        dataSource?.didSelectRow = { [weak self] (indexPath, item) in
            switch item?.property?.model?.pushType ?? .UNKNOWN {
            case .chat:
                let destVC = Storyboard<ChatVC>.Home.instantiateVC()
                destVC.thread = ChatThread.init(item?.property?.model)
                self?.pushVC(destVC)
            case .REQUEST_COMPLETED,
                 .REQUEST_ACCEPTED,
                 .CANCELED_REQUEST,
                 .REQUEST_FAILED,
                 .CHAT_STARTED,
                 .STARTED_REQUEST,
                 .REACHED,
                 .COMPLETED,
                 .START,
                 .START_SERVICE,
                 .CANCEL_SERVICE,
                 .UPCOMING_APPOINTMENT,
                 .REQUEST_EXTRA_PAYMENT:
                let destVC = Storyboard<ApptDetailVC>.Home.instantiateVC()
                destVC.requestID = item?.property?.model?.module_id
                self?.pushVC(destVC)
            case .CALL_CANCELED,
                 .CALL_ACCEPTED,
                 .CALL_RINGING,
                 .CALL:
                break
            case .AMOUNT_DEDCUTED, .AMOUNT_RECEIVED, .BOOKING_RESERVED, .ASKED_QUESTION, .BALANCE_FAILED, .BALANCE_ADDED:
                self?.pushVC(Storyboard<WalletVC>.Home.instantiateVC())
            case .QUESTION_ANSWERED:
                let destVC = Storyboard<QuestionDetailVC>.Home.instantiateVC()
                destVC.questionId = item?.property?.model?.module_id
                self?.pushVC(destVC)
            case .PRESCRIPTION_ADDED:
                let url = Configuration.getValue(for: .PROJECT_BASE_PATH) + APIConstants.pdf + "?request_id=\(/item?.property?.model?.module_id)&client_id=\(Configuration.getValue(for: .PROJECT_PROJECT_ID))&download"
                //for download --&download
                let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
                destVC.linkTitle = (url, VCLiteral.PRESC_DETAIL.localized)
                self?.pushVC(destVC)
            case .UNKNOWN:
                break
            }
        }
        
        dataSource?.refreshProgrammatically()
    }
    
    private func getNotificationsAPI(isRefreshing: Bool? = false) {
        
        EP_Home.notifications(after: /isRefreshing ? nil : after).request(success: { [weak self] (responseData) in
            let response = (responseData as? NotificationData)
            self?.after = response?.after
            if /isRefreshing {
                self?.items = response?.notifications
            } else {
                self?.items = (self?.items ?? []) + (response?.notifications ?? [])
            }
            /self?.items?.count == 0 ? self?.showVCPlaceholder(type: .NoNotifications, scrollView: self?.tableView) : ()
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
