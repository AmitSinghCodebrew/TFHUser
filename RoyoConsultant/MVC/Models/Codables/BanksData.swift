//
//  BanksData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import Foundation

final class BanksData: Codable {
    var bank_accounts: [Bank]?
}

final class Bank: Codable {
    var id: Int?
    var name: String?
    var bank_name: String?
    var account_number: String?
    var last_four_digit: String?
    var ifc_code: String?
    var account_holder_type: String
    var country: String?
    var currency: String?
    var created_at: String?
}
