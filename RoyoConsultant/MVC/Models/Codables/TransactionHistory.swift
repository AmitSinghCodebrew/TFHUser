//
//  TransactionHistory.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

final class TransactionData: Codable {
    var payments: [Payment]?
    var after: String?
    var before: String?
    
}

final class Payment: Codable {
    var id: Int?
    var from: User?
    var to: User?
    var transaction_id: Int?
    var created_at: String?
    var updated_at: String?
    var call_duration: Int?
    var service_type: String?
    var amount: Double?
    var type: TransactionType?
    var status: String?
    var closing_balance: Double?
}

final class WalletBalance: Codable {
    var balance: Double?
}

final class CardsData: Codable {
    var cards: [PaymentCard]?
}

final class PaymentCard: Codable {
    var id: Int?
    var card_brand: String?
    var last_four_digit: String?
    var created_at: String?
    var is_default: CustomBool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case card_brand
        case last_four_digit
        case created_at
        case is_default = "default"
    }
}

final class CreateRequestData: Codable {
    var amountNotSufficient: Bool?
    var total_charges: Double?
    var book_slot_time: String?
    var book_slot_date: String?
    var is_second_oponion: Bool?
    var request: Requests?
    var message: String?
    var minimum_balance: String?
}
