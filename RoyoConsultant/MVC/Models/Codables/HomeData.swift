//
//  HomeData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 05/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class HomeData: Codable {
    var top_doctors: [User]?
    var top_blogs: [Feed]?
    var top_articles: [Feed]?
    var promotional: [Feed]?
    var tips: [Tip]?
    var symptoms: [Symptom]?
    var questions: [Feed]?
    var testimonials: [Review]?
    var notification_count: Int?
}

final class Symptom: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var isSelected: Bool? = false
    var symptom_id: Int?
}

final class Tip: Codable {
    var id: Int?
    var title: String?
    var image: String?
    var description: String?
    var like: Int?
    var user_id: Int?
    var created_at: String?
    var views: Int?
    var favorite: Int?
    var comment_count: Int?
    var user_data: User?
    var is_favorite: Bool?
    var is_like: Bool?
}

final class SymptomsData: Codable {
    var symptoms: [Symptom]?
    var after: String?
    var before: String?
    
}
