//
//  FilterPopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 05/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class FilterPopUpVC: BaseVC {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerXIBForHeaderFooter(FilterHeaderView.identfier)
        }
    }
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var btnApply: SKButton!
    @IBOutlet weak var btnClear: UIButton!
    
    private var dataSource: TableDataSource<FilterHeaderProvider, FilterCellProvider, FilterCustomModel>?
    private var items: [FilterHeaderProvider]?
    public var filters: [Filter]?
    public var filtersApplied: ((_ _filters: [Filter]?, _ isCleared: Bool?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizedTextSetup()
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Cancel
            hideVisulEffectView(filterApplied: false, isCleared: false)
        case 1: //Apply
            if /filters?.compactMap({$0.options}).flatMap({$0}).filter({/$0.isSelected}).count == 0 {
                btnApply.vibrate()
            } else {
                hideVisulEffectView(filterApplied: true, isCleared: false)
            }
        case 2: //Clear all
            filters?.forEach({
                $0.options?.forEach({$0.isSelected = false })
            })
            hideVisulEffectView(filterApplied: true, isCleared: true)
        default:
            break
        }
    }
}

//MARK:- VCFuncs
extension FilterPopUpVC {
    
    private func localizedTextSetup() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = true
        lblTitle.text = VCLiteral.FILTERS.localized
        btnApply.setTitle(VCLiteral.APPLY.localized, for: .normal)
    }
    
    private func tableViewInit() {
        let requiredData = FilterHeaderProvider.getFilters(filters: filters)
        items = requiredData.filters
        tableHeight.constant = requiredData.tableHeight
        
        dataSource = TableDataSource<FilterHeaderProvider, FilterCellProvider, FilterCustomModel>.init(.MultipleSection(items: items ?? []), tableView, false)
        
        dataSource?.configureHeaderFooter = { (section, item, view) in
            (view as? FilterHeaderView)?.item = item
        }
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? FilterCollectionViewCell)?.item = item
        }
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView(filterApplied: Bool, isCleared: Bool) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                //CallBack
                if filterApplied {
                    self?.filtersApplied?(self?.filters, isCleared)
                }
            })
        }
    }
}
