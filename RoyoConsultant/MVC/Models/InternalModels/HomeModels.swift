//
//  HomeModels.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class HomeSectionProvider: HeaderFooterModelProvider {
    
    typealias CellModelType = HomeCellProvider
    
    typealias HeaderModelType = HomeSectionModel
    
    typealias FooterModelType = Any
    
    var headerProperty: (identifier: String?, height: CGFloat?, model: HomeSectionModel?)?
    
    var footerProperty: (identifier: String?, height: CGFloat?, model: Any?)?
    
    var items: [HomeCellProvider]?
    
    required init(_ _header: (identifier: String?, height: CGFloat?, model: HomeSectionModel?)?, _ _footer: (identifier: String?, height: CGFloat?, model: Any?)?, _ _items: [HomeCellProvider]?) {
        headerProperty = _header
        footerProperty = _footer
        items = _items
    }
    
    class func getBanners(_ banners: [Banner]?) -> HomeSectionProvider {
        let width = UIScreen.main.bounds.width
        let height = (width - 32) * 0.60465
         
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 0, lineSpacing: 0, edgeInsets: UIEdgeInsets.init(top: 16.0, left: 0, bottom: 0, right: 0))
        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top
        
        let section = HomeSectionProvider.init(nil, nil, [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, banners, BannerCell.identfier)), nil, nil)])
        return section
    }
    
    class func getCategoriesFor3Stacks(_ categories: [Category]?, isClasses: Bool?) -> [HomeSectionProvider]{
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        let height = width * 0.7
        
        var array = [[Category]]() // each array with 2 values and last index can be 3 also
        var tempArray = [Category]()
        
        let prefixedCat = Array(categories?.prefix(6) ?? [])
        
        for (index, item) in prefixedCat.enumerated() {
            if tempArray.count == 0 {
                tempArray.append(item)
                index == /prefixedCat.count - 1 ? array[array.count  - 1].append(item) : ()
            } else if /tempArray.count == 1  {
                tempArray.append(item)
                array.append(tempArray)
                tempArray = []
            }
        }
        
        var cells = [HomeCellProvider]()
        
        let tempSize = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 16.0, lineSpacing: 16.0, edgeInsets: UIEdgeInsets.init(top: 0, left: 16.0, bottom: 16.0, right: 16.0))

        
        array.forEach({
            cells.append(HomeCellProvider.init((Category3StackCell.identfier, height, HomeCellModel.init(tempSize, .vertical, $0, nil)), nil, nil))
        })
        
        let section = HomeSectionProvider.init((HomeSectionView.identfier, 92, HomeSectionModel.init(/isClasses ? .CLASSES : .MEET, .WITH_EXPERTS, _btnText: .VIEW_ALL, _isBtnHidden: !(prefixedCat.count < /categories?.count), _action: nil)), nil, cells)

        return [section]
    }
    
    class func getBlogs(feed: [Feed]) -> HomeSectionProvider? {
        let width = UIScreen.main.bounds.width * 0.4
        let height = width * (184 / 152)
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 0, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))
        
        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top
        
        let section = HomeSectionProvider.init((HomeSectionViewShort.identfier, 48.0, HomeSectionModel.init(.LATEST_BLOGS, .LATEST_BLOGS, _btnText: .VIEW_ALL, _isBtnHidden: feed.count < 5, _action: .ViewAllBogs)), nil, [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, Array(feed.prefix(5)), BlogCell.identfier)), nil, nil)])
        
        return feed.count == 0 ? nil : section
    }
    
    class func getQuestions(feed: [Feed]) -> HomeSectionProvider? {
        let width = UIScreen.main.bounds.width * 0.4
        let height = width * (184 / 152)
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 0, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))

        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top

        let section = HomeSectionProvider.init((HomeSectionViewShort.identfier, 48.0, HomeSectionModel.init(.ASK_FREE_QUESTIONS, .ASK_FREE_QUESTIONS, _btnText: .VIEW_ALL, _isBtnHidden: false, _action: .ViewAllQuestions)), nil, [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, Array(feed.prefix(5)), QuestionCell.identfier)), nil, nil)])
        
        return section
    }
    
    class func getArticles(feed: [Feed]) -> HomeSectionProvider? {
        let width = UIScreen.main.bounds.width * 0.4
        let height = width * (184 / 152)
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 0, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))
        
        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top
        
        let section = HomeSectionProvider.init((HomeSectionViewShort.identfier, 48.0, HomeSectionModel.init(.LATEST_ARTICLES, .LATEST_ARTICLES, _btnText: .VIEW_ALL, _isBtnHidden: feed.count < 5, _action: .ViewAllArticles)), nil, [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, Array(feed.prefix(5)), BlogCell.identfier)), nil, nil)])
        
        return section
    }
    
    class func getServices(tip: Tip?) -> HomeSectionProvider {
        var width = ((UIScreen.main.bounds.width - 80) / 4)
        let height = width + 48.0
        
        var services = AppSettings.homeScreenServices
        
        let tipCell = CustomService.init(#imageLiteral(resourceName: "ic_tip_of_the_day"), .TIP_OF_THE_DAY, .tipOfTheDay)
        tipCell.tip = tip
        
        if tip != nil {
            services.append(tipCell)
        }
        
        if services.count > 4 {
            width = width * 0.9
        }
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 0, lineSpacing: 16.0, edgeInsets: UIEdgeInsets.init(top: 24, left: 16, bottom: 0, right: 16))
        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top
        
        let section = HomeSectionProvider.init(nil, nil, [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, services, ServiceTypeCell.identfier)), nil, nil)])
        
        return section
    }
    
    class func getHealthTools() -> HomeSectionProvider {
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        let height = width * (112 / 168)
        
        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 16, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))
        
        return HomeSectionProvider.init((HomeSectionViewShort.identfier, 48.0, HomeSectionModel.init(.HEALTH_TOOL, .HEALTH_TOOL, _btnText: .VIEW_ALL, _isBtnHidden: true, _action: nil)), nil, [HomeCellProvider.init((HomeCollCell.identfier, sizeProvider.getHeightOfTableViewCell(for: 4, gridCount: 2), HomeCellModel.init(sizeProvider, .vertical, HealthTool.getTools(), HealthToolCell.identfier)), nil, nil)])
    }
    
    class func getTestimonials(reviews: [Review]?) -> HomeSectionProvider? {
        let width = (UIScreen.main.bounds.width - 32) * 0.9
        let height = width * (98 / 320)

        let sizeProvider = CollectionSizeProvider.init(cellSize: CGSize.init(width: width, height: height), interItemSpacing: 16, lineSpacing: 16, edgeInsets: UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))
        let heightOfTV_Cell = height + sizeProvider.edgeInsets.bottom + sizeProvider.edgeInsets.top

        let section = HomeSectionProvider.init((HomeSectionViewShort.identfier, 48.0, HomeSectionModel.init(.TESTIMONIALS, .TESTIMONIALS, _btnText: .VIEW_ALL, _isBtnHidden: true, _action: nil)), nil, [HomeCellProvider.init((HomeCollCell.identfier, heightOfTV_Cell, HomeCellModel.init(sizeProvider, .horizontal, reviews, TestimonialCell.identfier)), nil, nil)])

        return /reviews?.count == 0 ? nil : section
    }
}

class HomeSectionModel {
    var titleRegular: VCLiteral?
    var titleBold: VCLiteral?
    var btnText: VCLiteral?
    var isBtnHidden: Bool?
    var action: HeaderActionType?
    var extraPayment: ExtraPayment?
    
    #if NurseLynx
    var tier: Tier?
    #endif
    
    init(_ titleR: VCLiteral, _ titleB: VCLiteral, _btnText: VCLiteral, _isBtnHidden: Bool?, _action: HeaderActionType?) {
        titleRegular = titleR
        titleBold = titleB
        btnText = _btnText
        isBtnHidden = _isBtnHidden
        action = _action
    }
}

enum HeaderActionType {
    case ViewAllArticles
    case ViewAllBogs
    case ViewAllQuestions
    case MyQuestions
}

class HomeCellProvider: CellModelProvider {
    
    typealias CellModelType = HomeCellModel

    var property: (identifier: String, height: CGFloat, model: HomeCellModel?)?
    
    var leadingSwipeConfig: SKSwipeActionConfig?
    
    var trailingSwipeConfig: SKSwipeActionConfig?
    
    required init(_ _property: (identifier: String, height: CGFloat, model: HomeCellModel?)?, _ _leadingSwipe: SKSwipeActionConfig?, _ _trailingSwipe: SKSwipeActionConfig?) {
        property = _property
        leadingSwipeConfig = _leadingSwipe
        trailingSwipeConfig = _trailingSwipe
    }
}

class HomeCellModel {
    var collProvider: CollectionSizeProvider?
    var scrollDirection: UICollectionView.ScrollDirection?
    var collectionItems: [Any]?
    var identifier: String?
    
    init(_ _collProvider: CollectionSizeProvider, _ _scrollDirection: UICollectionView.ScrollDirection, _ _collectionItems: [Any]?, _ _identifier: String?) {
        collProvider = _collProvider
        scrollDirection = _scrollDirection
        collectionItems = _collectionItems
        identifier = _identifier
    }
}

class CustomService {
    var image: UIImage?
    var title: VCLiteral?
    var type: ServiceType?
    var tip: Tip?
    
    init(_ _image: UIImage?, _ _title: VCLiteral?, _ _type: ServiceType) {
        image = _image
        title = _title
        type = _type
    }
}

class HealthTool {
    var image: UIImage?
    var title: VCLiteral?
    var subtitle: VCLiteral?
    
    init(_ _image: UIImage?, _ _title: VCLiteral, _ _subtitle: VCLiteral) {
        image = _image
        title = _title
        subtitle = _subtitle
    }
    
    class func getTools() -> [HealthTool] {
        return [HealthTool(#imageLiteral(resourceName: "ic_bmi"), .HEALTH_TOOL_01_TITLE, .HEALTH_TOOL_01_SUBTITLE),
                HealthTool(#imageLiteral(resourceName: "ic_water"), .HEALTH_TOOL_02_TITLE, .HEALTH_TOOL_02_SUBTITLE),
                HealthTool(#imageLiteral(resourceName: "ic_protein"), .HEALTH_TOOL_03_TITLE, .HEALTH_TOOL_03_SUBTITLE),
                HealthTool(#imageLiteral(resourceName: "ic_pregnancy"), .HEALTH_TOOL_04_TITLE, .HEALTH_TOOL_04_SUBTITLE)]
    }
}
