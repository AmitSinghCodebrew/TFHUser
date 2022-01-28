//
//  CouponsData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 08/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class CouponsData: Codable {
    var coupons: [Coupon]?
    var after: String?
    var before: String?
    
}

final class Coupon: Codable {
    var id: Int?
    var category_id: Int?
    var service_id: Int?
    var minimum_value: String?
    var start_date: String?
    var end_date: String?
    var limit: Int?
    var coupon_code: String?
    var maximum_discount_amount: String?
    var discount_type: DiscountType?
    var discount_value: String?
    var service: Service?
    var category: Category?
    
    init() {
        
    }
}
