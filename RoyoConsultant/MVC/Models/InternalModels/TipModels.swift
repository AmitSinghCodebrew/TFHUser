//
//  TipModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TipSectionPro: HeaderFooterModelProvider {
    
    typealias CellModelType = TipCellPro
    
    typealias HeaderModelType = TipHeaderData
    
    typealias FooterModelType = Any
    
    var headerProperty: HeaderProperty?
    
    var footerProperty: FooterProperty?
    
    var items: [TipCellPro]?
    
    required init(_ _header: HeaderProperty?, _ _footer: FooterProperty?, _ _items: [TipCellPro]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getItems(tip: Tip?) -> [TipSectionPro] {
        let tipSection = TipSectionPro.init((TipHeaderView.identfier, 48.0, TipHeaderData.init(/tip?.title)), nil, [TipCellPro.init((TipDetailCell.identfier, UITableView.automaticDimension, TipOrComment.init(tip)), nil, nil)])
        

        
        return [tipSection]
    }
    
    class func getComments(comments: [Comment]?) -> TipSectionPro? {
        var reviewCells = [TipCellPro]()
        
        comments?.forEach { (comment) in
            reviewCells.append(TipCellPro.init((TipCommentCell.identfier, UITableView.automaticDimension, TipOrComment.init(comment)), nil, nil))
        }
        
        let reviewSection = TipSectionPro.init((TipHeaderView.identfier, 48.0, TipHeaderData.init(VCLiteral.ALL_COMMENTS.localized)), nil, reviewCells)
        return /comments?.count == 0 ? nil : reviewSection
    }
}

class TipHeaderData {
    var title: String?
    
    init(_ text: String?) {
        title = text
    }
}
class TipCellPro: CellModelProvider {
    
    typealias CellModelType = TipOrComment

    var property: Property?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: Property?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
}

class TipOrComment {
    var tip: Tip?
    var comment: Comment?
    
    
    init(_ _comment: Comment?) {
        comment = _comment
    }
    
    init(_ _tip: Tip?) {
        tip = _tip
    }
}
