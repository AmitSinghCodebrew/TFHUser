//
//  ClassesData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 11/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class ClassesData: Codable {

    var classes: [ClassObj]?
    var after: String?
    var before: String?
}

final class ClassObj: Codable {
    var id: Int?
    var name: String?
    var status: ClassStatus?
    var calling_type: String?
    var class_date: String?
    var created_at: String?
    var bookingDateUTC: String?
    var price: Double?
    var category_id: Int?
    var created_by: User?
    var booking_date: String?
    var time: String?
    var category_data: Category?
    var isOccupied: Bool?
    var enroll_user_data: [User]?
    
}
