//
//  ApptDetailVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 02/12/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ApptDetailVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(HomeSectionViewShort.identfier)
        }
    }
    
    var request: Requests? {
        didSet {
            requestID = request?.id
        }
    }
    var requestID: Int?
    private var items: [ApptDetailHeader]?
    private var dataSource: TableDataSource<ApptDetailHeader, AppDetailCellModel, ApptDetailData>?
    var requestUpdated: ((_ request: Requests?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = VCLiteral.APPT_DETAIL.localized
        tableViewInit()
        if let _ = requestID {
            getApptDetailAPI()
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        popVC()
    }
}

//MARK:- VCFUncs
extension ApptDetailVC {
    public func refreshViaNotification() {
        requestID = request?.id
        getApptDetailAPI()
    }
    
    private func tableViewInit() {
        
        tableView.contentInset.bottom = 16.0
        
        dataSource = TableDataSource<ApptDetailHeader, AppDetailCellModel, ApptDetailData>.init(.MultipleSection(items: ApptDetailHeader.getArray(request: request)), tableView, false)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? ApptShortCell)?.item = item
            (cell as? ApptShortCell)?.didReloadCell = { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                self?.requestUpdated?(item?.property?.model?.request)
            }
            (cell as? ExtraPaymentCell)?.item = item
            (cell as? ExtraPaymentCell)?.extraPaymentPaid = { [weak self] in
                self?.request?.extra_payment?.status = .paid
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: ApptDetailHeader.getArray(request: self?.request)), .FullReload)
            }
            (cell as? ApptDetailCollCell)?.item = item
            (cell as? SymptomInfoCell)?.item = item
            (cell as? MedicalRecordCell)?.item = item
            #if NurseLynx
            (cell as? ApptDetailCarePlanCell)?.item = item
            #elseif CloudDoc
            (cell as? QuestionAnswerCell)?.item = item
            #endif
        }
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? HomeSectionViewShort)?.item2 = item
        }
    }
    
    private func getApptDetailAPI() {
        playLineAnimation()
        EP_Home.apptDetail(id: requestID).request { [weak self] (responseData) in
            self?.request = (responseData as? RequestData)?.request_detail
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: ApptDetailHeader.getArray(request: self?.request)), .FullReload)
            self?.requestUpdated?(self?.request)
            self?.stopLineAnimation()
        } error: { [weak self] (error) in
            self?.stopLineAnimation()
        }
    }
}

