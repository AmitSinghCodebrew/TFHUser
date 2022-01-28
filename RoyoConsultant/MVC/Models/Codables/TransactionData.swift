//
//  TransactionData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 02/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class StripeData: Codable {
    var transaction_id: String?
    var requires_source_action: Bool?
    var url: String?
    
}
