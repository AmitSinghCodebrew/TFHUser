//
//  User.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class User: Codable {
    var id: Int?
    var name: String?
    var phone: String?
    var country_code: String?
    var profile_image: String?
    var fcm_id: String?
    var email: String?
    var provider_type: ProviderType?
    var stripe_id: String?
    var stripe_account_id: String?
    var socket_id: String?
    var token: String?
    var categoryData: Category?
    var services: [Service]?
    var filters: [Filter]?
    var profile: ProfileUser?
    var account_verified: Bool?
    var dob: String?
    var totalRating: Double?
    var reviewCount: Int?
    var qualification: String?
    var speciality: String?
    var call_price: String?
    var chat_price: String?
    var reference_code: String?
    var patientCount: Int?
    var consultationCount: Int?
    var insurances: [Insurance]?
    var insurance_info: [InsuranceInfo]?
    var custom_fields: [CustomField]?
    var master_preferences: [Filter]?
    var family_members: [FamilyMember]?
    var is_agreed: Bool?
    var medical_history: [MedicalHistory]?
    var category: String?
    var national_id: String?
}

final class ProfileUser: Codable {
    var id: Int?
    var address: String?
//    var avatar: Any?
    var dob: String?
//    var qualification: Any?
    var city: String?
    var state: String?
    var country: String?
    var experience: String?
    var speciality: String?
    var rating: Double?
    var about: String?
    var user_id: Int?
    var lat: String?
    var long: String?
    var bio: String?
    var title: String?
    var working_since: String?
    var country_id: String?
    var state_id: String?
    var city_id: String?

}

