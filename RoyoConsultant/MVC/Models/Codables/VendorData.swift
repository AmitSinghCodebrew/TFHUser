//
//  VendorData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class VendorData: Codable {
    var vendors: [Vendor]?
    var next_page_url: String?
    var prev_page_url: String?

    private enum CodingKeys: String, CodingKey {
        case vendors = "doctors"
        case next_page_url
        case prev_page_url
    }
}

final class Vendor: Codable {
    var id: Int?
    var sp_id: Int?
    var category_service_id: Int?
    var available: CustomBool?
    var duration: String?
    var price: Double?
    var service_type: String?
    var vendor_data: User?
    var distance: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case sp_id
        case category_service_id
        case available
        case duration
        case service_type
        case price
        case distance
        case vendor_data = "doctor_data"
    }
}

final class VendorDetailData: Codable {
    var vendor_data: User?
    
    private enum CodingKeys: String, CodingKey {
        case vendor_data = "dcotor_detail"
    }
}


