//
//  MasterPreferences.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 01/01/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import Foundation

final class MasterPreferences: Codable {
    var preferences: [Filter]?
}

extension Array where Element == Filter {
    func getLanguagePrefrence() -> Filter? {
        return self.first(where: {$0.preference_name == "Languages"})
    }
    
    func getGenderPreference() -> Filter? {
        return self.first(where: {$0.preference_name == "Gender"})
    }
}
