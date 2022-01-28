//
//  ResponseTimePopUpVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class ResponseTimePopUpVC: BaseVC {
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var dataSource: TableDataSource<DefaultHeaderFooterModel<Package>, DefaultCellModel<Package>, Package>?
    var didTapped: ((_ obj: Package?) -> Void)?
    var items: [Package]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView.isHidden = true
        tableViewInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.unhideVisualEffectView()
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        hideVisulEffectView(obj: nil)
    }
}

//MARK:- VCFuncs
extension ResponseTimePopUpVC {
    private func tableViewInit() {
        let width = UIScreen.main.bounds.width - 32
        let height = (width * (97 / 344)) + 16

        let maxHeight = UIScreen.main.bounds.height - 128
        let totalHeight = (CGFloat(/items?.count) * height) + 16
   
        tableView.contentInset.top = 8.0
        tableView.contentInset.bottom = 8.0
        
        viewHeight.constant = totalHeight > maxHeight ? maxHeight : totalHeight
        
        dataSource = TableDataSource.init(.SingleListing(items: items ?? [], identifier: ResponseTimeCell.identfier, height: height, leadingSwipe: nil, trailingSwipe: nil), tableView)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? ResponseTimeCell)?.item = item
        }
        
        dataSource?.didSelectRow = { (indexPath, item) in
            self.hideVisulEffectView(obj: item?.property?.model)
        }
    }
    
    private func unhideVisualEffectView() {
        visualEffectView.alpha = 0
        visualEffectView.isHidden = false
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.visualEffectView.alpha = 1.0
        }
    }
    
    private func hideVisulEffectView(obj: Package?) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.visualEffectView.alpha = 0.0
        }) { [weak self] (finished) in
            self?.visualEffectView.isHidden = true
            self?.dismiss(animated: true, completion: {
                obj == nil ? () : self?.didTapped?(obj)
            })
        }
    }
}
