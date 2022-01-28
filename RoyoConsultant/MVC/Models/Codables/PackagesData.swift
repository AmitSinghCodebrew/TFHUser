//
//  PackagesData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/08/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class PackagesData: Codable {
    var after: String?
    var before: String?
    
    #if CloudDoc
    var plans: [Package]?
    var active_plan: Bool?
    #else
    var support_packages: [Package]?
    var packages: [Package]?
    #endif
    var amountNotSufficient: Bool?
    var detail: Package?
}

final class Package: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var price: Double?
    var image: String?
    var total_requests: Int?
    var category_id: Int?
    var subscribe: Bool?
    var image_icon: String?
    var color_code: String?
    #if CloudDoc
    var type: String?
    var available_requests: Int?
    var expired_on_plan: String? 
    #endif
}
