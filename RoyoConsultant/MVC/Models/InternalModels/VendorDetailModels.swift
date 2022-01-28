//
//  VendorDetailModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class VD_HeaderFooter_Provider: HeaderFooterModelProvider {
    
    typealias CellModelType = VD_Cell_Provider
    
    typealias HeaderModelType = VD_Header_Modal
    
    typealias FooterModelType = Any
    
    var headerProperty: (identifier: String?, height: CGFloat?, model: VD_Header_Modal?)?
    
    var footerProperty: (identifier: String?, height: CGFloat?, model: Any?)?
    
    var items: [VD_Cell_Provider]?
    
    required init(_ _header: (identifier: String?, height: CGFloat?, model: VD_Header_Modal?)?, _ _footer: (identifier: String?, height: CGFloat?, model: Any?)?, _ _items: [VD_Cell_Provider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getItems(_ vendor: User?, serviceType: ServiceType?) -> [VD_HeaderFooter_Provider] {
        var items = [VD_HeaderFooter_Provider]()
        
        let obj = vendor
        
        var stringsArray = [String]()
        
        obj?.custom_fields?.forEach({ (field) in
            stringsArray.append("\(/field.field_name): \(/field.field_value)")
        })
        
        obj?.master_preferences?.forEach({ (filter) in
            let options = filter.options?.filter({/$0.isSelected})
            if /options?.count != 0 {
                let optionsString = /options?.map({/$0.option_name}).joined(separator: ", ")
                stringsArray.append("\(/filter.preference_name): \(optionsString)")
            }
        })
        
        #if Heal
        
        #else
        if /stringsArray.count != 0 {
            items.append(VD_HeaderFooter_Provider.init(nil, nil, [VD_Cell_Provider.init((VendorExtraInfoCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, nil, nil, _vendor: vendor)), nil, nil)]))
        }
        #endif      
        
        if serviceType == .home_visit || serviceType == .clinic_visit {
            
        } else if /vendor?.services?.count != 0 {
            let widthOfBtn = (UIScreen.main.bounds.width - 48.0) / 2.0
            let heightOfBtn = widthOfBtn * 0.39024
            
            let collectionTopSpace: CGFloat = 16.0
            let collectionBottomSpace: CGFloat = 16.0
            let interItemSpacing: CGFloat = 16.0
            let numberOfDualRows = round((CGFloat(/vendor?.services?.count) / 2.0) + 0.1)
            let heightOfTVCell = (numberOfDualRows * heightOfBtn) + (interItemSpacing * (numberOfDualRows - 1.0)) + collectionTopSpace + collectionBottomSpace
            
            items.append(VD_HeaderFooter_Provider.init(nil, nil, [VD_Cell_Provider.init((VendorDetailCollectionTVCell.identfier, heightOfTVCell, VD_Modal.init(vendor?.services, nil, nil, _vendor: vendor)), nil, nil)]))
        }
        
        items.append(VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.ABOUT.localized, nil)), nil, [VD_Cell_Provider.init((AboutCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, (vendor?.profile?.bio, false), nil, _vendor: vendor)), nil, nil)]))
        
        return items
    }
    
    class func getReviewsSection(_ vendor: User?, reviews: [Review]?) -> VD_HeaderFooter_Provider {
        var cellItems = [VD_Cell_Provider]()
        reviews?.forEach {
            cellItems.append(VD_Cell_Provider.init((ReviewCell.identfier, UITableView.automaticDimension, VD_Modal.init(nil, nil, $0, _vendor: vendor)), nil, nil))
        }
        
        let section = VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.REVIEWS.localized, vendor?.totalRating)), nil, cellItems)
        
        return section
    }
    
    class func getClasses(classes: [ClassObj]?) -> VD_HeaderFooter_Provider? {
        var cells = [VD_Cell_Provider]()
        let tempClass = Array((classes ?? []).prefix(2))
        tempClass.forEach({ (obj) in
            cells.append(VD_Cell_Provider.init((ClassCell.identfier, UITableView.automaticDimension, VD_Modal.init(obj)), nil, nil))
        })
        let section = VD_HeaderFooter_Provider.init((VendorDetailHeaderView.identfier, 40.0, VD_Header_Modal.init(VCLiteral.CLASSES.localized, nil, /classes?.count > 2)), nil, cells)
        return /classes?.count == 0 ? nil : section
    }
    
}

class VD_Cell_Provider: CellModelProvider {
    
    typealias CellModelType = VD_Modal
    
    var property: (identifier: String, height: CGFloat, model: VD_Modal?)?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: (identifier: String, height: CGFloat, model: VD_Modal?)?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
    
}

class VD_Modal {
    var subscriptions: [Service]?
    var about: (text: String?, isAllText: Bool?)?
    var review: Review?
    var vendor: User?
    var classObj: ClassObj?
    
    init(_ _subs: [Service]?, _ _about: (text: String?, isAllText: Bool?)?, _ _review: Review?, _vendor: User?) {
        subscriptions = _subs
        about = _about
        review = _review
        vendor = _vendor
    }
    
    init(_ _class: ClassObj?) {
        classObj = _class
    }
}

class VD_Header_Modal {
    var title: String?
    var rating: Double?
    var isViewAllShown: Bool? = false
    
    init(_ _title: String?, _ _rating: Double?, _ _isViewAllShown: Bool? = false) {
        title = _title
        rating = _rating
        isViewAllShown = _isViewAllShown
    }
}
