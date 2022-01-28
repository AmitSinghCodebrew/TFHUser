//
//  CommentData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 06/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class CommentData: Codable {
    var comments: [Comment]?
    var comment: Comment?
    var after: String?
    var before: String?
    
}

final class Comment: Codable {
    var feed_id: Int?
    var comment: String?
    var user_id: Int?
    var updated_at: String?
    var created_at: String?
    var id: Int?
    var user: User?
}
