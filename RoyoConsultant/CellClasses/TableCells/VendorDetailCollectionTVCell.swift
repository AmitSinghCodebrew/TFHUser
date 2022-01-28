//
//  VendorDetailCollectionTVCell.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VendorDetailCollectionTVCell: UITableViewCell, ReusableCell {
    
    typealias T = VD_Cell_Provider
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    private var dataSource: CollectionDataSource?
    var consultFor: ((_ service: Service?) -> Void)?
    
    var item: VD_Cell_Provider? {
        didSet {
            collectionViewInit()
        }
    }
    
    private func collectionViewInit() {
        
        let widthOfBtn = (UIScreen.main.bounds.width - 48.0) / 2.0
        let heightOfBtn = widthOfBtn * 0.39024
        
        dataSource = CollectionDataSource.init(item?.property?.model?.subscriptions, VendorDetailBtnCell.identfier, collectionVIew, CGSize.init(width: widthOfBtn, height: heightOfBtn), UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16), 16, 16, .vertical)
        
        dataSource?.configureCell = { (cell, item, indexPath) in
            (cell as? VendorDetailBtnCell)?.item = item
        }
        
        dataSource?.didSelectItem = { [weak self] (indexPath, item) in
            self?.consultFor?(item as? Service)
        }
    }
}
