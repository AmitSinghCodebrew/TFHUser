//
//  NotificationData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 26/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class NotificationData: Codable {
    var after: String?
    var before: String?
    
    var notifications: [NotificationModel]?
}

final class NotificationModel: Codable {
    var id: Int?
    var pushType: PushType?
    var message: String?
    var module: String?
    var read_status: String?
    var created_at: String?
    var form_user: User?
    var to_user: User?
    var module_id: Int?
    var sentAt: Double?
}
