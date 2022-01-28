//
//  Banners.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 19/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class BannersData: Codable {
    var banners: [Banner]?
    var after: Int?
    var before: Int?
    
}

final class Banner: Codable {
    var id: Int?
    var image_web: String?
    var image_mobile: String?
    var position: String?
    var banner_type: BannerType?
    var start_date: String?
    var end_date: String?
    var category_id: Int?
    var sp_id: Int?
    var class_id: Int?
    var category: Category?
    var service_provider: User?
}
