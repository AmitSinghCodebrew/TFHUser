//
//  SlotsData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 10/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class SlotsData: Codable {
    var slots: [Slot]?
    var interval: [Interval]?
    var date: String?
}

final class Slot: Codable {
    var start_time: String?
    var end_time: String?
}

final class Interval: Codable {
    var time: String?
    var available: Bool?
    
    //Extra local key
    var isSelected: Bool? = false
}
