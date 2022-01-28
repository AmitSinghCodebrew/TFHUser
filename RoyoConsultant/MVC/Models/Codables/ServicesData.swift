//
//  ServicesData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 04/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class ServicesData: Codable {
    var services: [Service]?
    var after: String?
    var before: String?
    
}

final class Service: Codable {
    var id: Int?
    var category_id: Int?
    var service_id: Int?
    var available: CustomBool?
    var price_minimum: Double?
    var price_maximum: Double?
    var minimum_duration: Double?
    var gap_duration: Double?
    var duration: String?
    var name: String?
    var unit_price: Double?
    var color_code: String?
    var description: String?
    var need_availability: CustomBool?
    var price_fixed: Double?
    var price_type: PriceType?
    var minimmum_heads_up: String?
    var price: Double?
    var category_service_id: Int?
    var service_name: String?
    var main_service_type: ServiceType?
    //Additional Property not from backend
    var isSelected: Bool? = false
    var clinic_address: ClinicAddress?

    func isLocationLinked() -> Bool {
        switch main_service_type {
        case .audio_call, .video_call, .chat, .call:
            return false
        case .home_visit:
            return true
        default:
            return false
        }
    }
    
    init(_ _name: String?) {
        service_name = _name
        name = _name
        isSelected = true
    }
    
    init(serviceId: Int?, categoryId: Int?) {
        service_id = serviceId
        category_id = categoryId
    }
    
    public func isClinicAddress() -> Bool {
        return main_service_type == .clinic_visit
    }
}


class ClinicAddress: Codable {
    var locationName: String?
    var lat: Double?
    var long: Double?
}
