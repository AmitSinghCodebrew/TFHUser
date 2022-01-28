//
//  CarePlan.swift
//  NurseLynx
//
//  Created by Sandeep Kumar on 15/04/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit

class QuestionAnswer: Codable {
    var question: String?
    var answer: String?
    var request_id: Int?
    var id: Int?
    
    init(_ _question: String?, _ _answer: String?) {
        question = _question
        answer = _answer
    }
}

class TiersData: Codable {
    var tiers: [Tier]?
}

class Tier: Codable {
    var id: Int?
    var title: String?
    var price: Double?
    var tier_options: [TierOption]?
    
    var isSelected: Bool?
    
    func getOptionsForBackend() -> Any? {
        var tempOptions = [TierOption]()
        tempOptions = tier_options ?? []
        tempOptions.forEach({
            $0.tier_id = nil
            $0.title = nil
        })
        let filtered = tempOptions.filter({ ($0.type ?? .None) != .None })
        return JSONHelper<[TierOption]>().toDictionary(model: filtered)
    }
}

class TierOption: Codable {
    var id: Int?
    var title: String?
    var tier_id: Int?
    var status: CarePlanStatus?
    
    var type: TierOptionToggle?
}

enum CarePlanStatus: String, Codable, CaseIterableDefaultsLast {
    case completed
    case pending
    
    var title: String {
        switch self {
        case .completed:
            return VCLiteral.COMPLETE.localized
        case .pending:
            return "Pending"
        }
    }
}

enum TierOptionToggle: String, Codable, CaseIterableDefaultsLast {
    case NeedSomeHelp = "1"
    case NeedMuchHelp = "2"
    case None = "3"
    
    #if NurseLynx
    var localized: String {
        switch self {
        case .NeedSomeHelp:
            return VCLiteral.NeedSomeHelp.localized
        case .NeedMuchHelp:
            return VCLiteral.NeedMuchHelp.localized
        case .None:
            return ""
        }
    }
    #endif
}

class TierHeaderProvider: HeaderFooterModelProvider {
    typealias CellModelType = TierCellProvider
    
    typealias HeaderModelType = Tier
    
    typealias FooterModelType = Any
    
    var headerProperty: HeaderProperty?
    
    var footerProperty: FooterProperty?
    
    var items: [TierCellProvider]?
    
    required init(_ _header: HeaderProperty?, _ _footer: FooterProperty?, _ _items: [TierCellProvider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    #if NurseLynx
    
    class func getSections(tiers: [Tier]?) -> [TierHeaderProvider] {
        var sections = [TierHeaderProvider]()
        tiers?.forEach({ (item) in
            sections.append(TierHeaderProvider.init((CarePlanHeaderView.identfier, 56, item), nil, [TierCellProvider]()))
        })
        return sections
    }
    
    #endif
}

class TierCellProvider: CellModelProvider {
    typealias CellModelType = TierOption
    var property: Property?
    var leadingSwipeConfig: SKSwipeActionConfig?
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: Property?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
     
    #if NurseLynx
    class func getCells(options: [TierOption]?) -> [TierCellProvider] {
        var cells = [TierCellProvider]()
        options?.forEach({ (option) in
            cells.append(TierCellProvider.init((CarePlanCell.identfier, UITableView.automaticDimension, option), nil, nil))
        })
        return cells
    }
    #endif
}
