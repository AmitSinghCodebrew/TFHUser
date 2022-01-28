//
//  ReviewsData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 07/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class ReviewsData: Codable {
    var review_list: [Review]?
    var after: String?
    var before: String?
    
}

final class Review: Codable {
    var id: Int?
    var from_user: Int?
    var rating: Double?
    var comment: String?
    var user: User?
    var consultant_id: Int?
    var consultant: User?
    
    var isReadMoreTapped: Bool?
}
