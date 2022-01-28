//
//  FamilyData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 27/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class FamilyData: Codable {
    var family: FamilyMember?
}


final class FamilyMember: Codable {
    var id: Int?
    var user_id: Int?
    var first_name: String?
    var last_name: String?
    var relation: String?
    var gender: String?
    var age: Int?
    var height: Double?
    var weight: Double?
    var blood_group: String?
    var image: String?
    var created_at: String?
    var updated_at: String?
    
    init(_ _id: Int?, _ _name: String?, _ _image: String?) {
        id = _id
        relation = _name
        image = _image
    }
}
