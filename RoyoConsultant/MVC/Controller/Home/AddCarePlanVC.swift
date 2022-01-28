//
//  AddCarePlanVC.swift
//  NurseLynx
//
//  Created by Sandeep Kumar on 15/04/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class AddCarePlanVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPlans: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(CarePlanHeaderView.identfier)
        }
    }
    @IBOutlet weak var btnDone: SKButton!
    @IBOutlet weak var btnSkip: RTLSupportedButton!

    private var dataSource: TableDataSource<TierHeaderProvider, TierCellProvider, TierOption>?
    private var items = [TierHeaderProvider]()
    
    var request: Requests?
    var didTapAdd: ((_ _tier: Tier?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedSetup()
        tableViewInit()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Back
            popVC()
        case 2: //DONE
            let selectedTier: Tier? = items.first(where: { /$0.items?.count != 0 })?.headerProperty?.model
            let tierOptions: [TierOption] = items.first(where: { /$0.items?.count != 0 })?.items?.compactMap({$0.property?.model}) ?? []
            selectedTier?.tier_options = tierOptions
            didTapAdd?(selectedTier)
            popVC()
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension AddCarePlanVC {
    private func getTiers() {
        EP_Home.tiers.request { [weak self] (responseData) in
            self?.items = TierHeaderProvider.getSections(tiers: (responseData as? TiersData)?.tiers)
            self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            self?.dataSource?.stopInfiniteLoading(.FinishLoading)
        } error: { (error) in
            
        }
    }
    
    private func localizedSetup() {
        lblTitle.text = VCLiteral.CARE_PLAN.localized
        lblPlans.text = VCLiteral.CARE_PLAN_NOTE.localized
        btnDone.setTitle(VCLiteral.DONE.localized, for: .normal)
    }
    
    private func tableViewInit() {
        dataSource = TableDataSource<TierHeaderProvider, TierCellProvider, TierOption>.init(.MultipleSection(items: items), tableView, true)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? CarePlanHeaderView)?.item = item
            (view as? CarePlanHeaderView)?.didTap = { [weak self] in
                self?.items.forEach({ $0.items = [] })
                item.items = TierCellProvider.getCells(options: item.headerProperty?.model?.tier_options)
                self?.items[section] = item
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            }
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? CarePlanCell)?.item = item
            (cell as? CarePlanCell)?.reloadCell = { [weak self] (tierOption) in
                self?.items[indexPath.section].items?[indexPath.row] = tierOption!
                self?.dataSource?.updateAndReload(for: .MultipleSection(items: self?.items ?? []), .FullReload)
            }
        }
        
        dataSource?.addPullToRefresh = { [weak self] in
            self?.getTiers()
        }
        
        dataSource?.refreshProgrammatically()
    }
}
