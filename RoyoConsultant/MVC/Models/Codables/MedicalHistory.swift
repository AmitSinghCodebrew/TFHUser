//
//  MedicalHistory.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/06/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import Foundation

final class MedicalHistory: Codable {
    var id: Int?
    var request_id: Int?
    var comment: String?
    var request: Requests?
}

final class MedicalHistoryData: Codable {
    var doctors: [User]?
    var after: String?
    var before: String?
    var per_page: Int?
}
