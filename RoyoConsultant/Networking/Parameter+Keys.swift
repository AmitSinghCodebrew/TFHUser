//
//  Parameter+Keys.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

typealias OptionalDictionary = [String : Any]?

extension Sequence where Iterator.Element == Keys {
    func map(values: [Any?]) -> OptionalDictionary {
        var params = [String : Any]()
        
        for (index,element) in zip(self,values) {
            if element != nil {
                params[index.rawValue] = element
            }
        }
        return params
    }
}

enum Keys: String {
    case provider_type
    case provider_id
    case provider_verification
    case user_type
    case country_code
    case name
    case email
    case password
    case phone
    case code
    case fcm_id
    case dob
    case bio
    case profile_image
    case speciality
    case call_price
    case chat_price
    case category_id
    case experience
    case otp
    case date
    case service_type
    case parent_id
    case filter_option_ids
    case vendor_id = "doctor_id"
    case request_id
    case after
    case image
    case transaction_type
    case card_number
    case exp_month
    case exp_year
    case cvc
    case balance
    case card_id
    case consultant_id
    case schedule_type
    case type
    case CategoryId
    case question_id
    case time
    case service_id
    case coupon_code
    case search
    case review
    case rating
    case class_id
    case status
    case apn_token
    case app_type
    case current_version
    case device_type
    case country_id
    case state_id
    case address
    case country
    case state
    case city
    case insurance_enable
    case insurances
    case custom_fields
    case list_by
    case package_id
    case plan_id
    case favorite
    case comment
    case lat
    case long
    case service_address
    case title
    case description
    case order_id
    case razorpayPaymentId
    case amount
    case symptom_id
    case option_ids
    case symptom_details
    case second_oponion
    case images
    case limit
    case quantity
    case per_page
    case current_password
    case new_password
    case first_name
    case last_name
    case relation
    case gender
    case age
    case height
    case weight
    case blood_group
    case optionals
    case medical_allergies
    case chronic_diseases
    case previous_surgeries
    case previous_medication
    case patient_type
    case chronic_diseases_desc
    case page
    case payment_method
    case resourcePath
    case insurance_info
    case master_preferences
    case invite_code
    case call_id
    case cancel_reason
    case tier_id
    case tier_options
    case account_holder_name
    case account_number
    case bank_name
    case bank_id
    case is_agreed
    case address_id
    
    case end_date
    case end_time
    case national_id
}

struct Parameters {
    static let login: [Keys] = [.provider_type, .provider_id, .provider_verification, .user_type, .country_code, .is_agreed]
    
    static let register: [Keys] = [.name, .email, .password, .phone, .code, .user_type, .fcm_id, .country_code, .dob, .bio, .profile_image, .master_preferences, .country, .invite_code, .is_agreed]
    
    static let profileUpdate: [Keys] = [.name, .email, .phone, .country_code, .dob, .bio, .speciality, .call_price, .chat_price, .category_id, .experience, .profile_image, .master_preferences, .country, .invite_code, .is_agreed, .national_id]
    
    static let updatePhone: [Keys] = [.phone, .country_code, .otp]
    
    static let updateFCMId: [Keys] = [.fcm_id]
    
    static let email: [Keys] = [.email]
    
    static let verifyEmail: [Keys] = [.email, .otp]
    
    static let changePsw: [Keys] = [.current_password, .new_password]
    
    static let sendOTP: [Keys] = [.phone, .country_code]
    
    static let requests: [Keys] = [.date, .service_type, .after, .second_oponion, .type]
    
    static let categories: [Keys] = [.parent_id, .after, .per_page]
    
    static let vendorList: [Keys] = [.category_id, .filter_option_ids, .service_id, .search, .page, .per_page, .service_type, .lat, .long, .after]
    
    static let vendorDetail: [Keys] = [.vendor_id]
    
    static let chatMessages: [Keys] = [.request_id, .after]
    
    static let endChat: [Keys] = [.request_id]
    
    static let transactionHistory: [Keys] = [.transaction_type, .after]
    
    static let addCard: [Keys] = [.card_number, .exp_month, .exp_year, .cvc]
    
    static let addMoney: [Keys] = [.balance, .card_id]
    
    static let createRequest: [Keys] = [.consultant_id, .date, .time, .service_id, .schedule_type, .coupon_code, .request_id, .lat, .long, .service_address, .second_oponion, .title, .images, .tier_id, .tier_options, .end_date, .end_time]
    
    static let notifications: [Keys] = [.after]
    
    static let classes: [Keys] = [.type, .CategoryId, .after, .vendor_id]
    
    static let services: [Keys] = [.category_id]
    
    static let getFilters: [Keys] = [.category_id]
    
    static let addReview: [Keys] = [.consultant_id, .request_id, .review, .rating]
    
    static let getReviews: [Keys] = [.vendor_id, .after]
    
    static let deleteCard: [Keys] = [.card_id]
    
    static let updateCard: [Keys] = [.card_id, .name, .exp_month, .exp_year]
    
    static let coupons: [Keys] = [.category_id, .service_id]
    
    static let confirmRequest: [Keys] = [.consultant_id, .date, .time, .service_id, .schedule_type, .coupon_code, .request_id, .tier_id]
    
    static let getSlots: [Keys] = [.vendor_id, .date, .service_id, .category_id]
    
    static let enrollUser: [Keys] = [.class_id]
    
    static let classJoin: [Keys] = [.class_id]
    
    static let cancelRequest: [Keys] = [.request_id, .cancel_reason]
    
    static let makeCall: [Keys] = [.request_id]
    
    static let callStatus: [Keys] = [.request_id, .status, .call_id]
    
    static let chatListing: [Keys] = [.after]
    
    static let appversion: [Keys] = [.app_type, .current_version, .device_type]
    
    static let clientDetail: [Keys] = [.app_type]
    
    static let countryData: [Keys] = [.type, .country_id, .state_id]
    
    static let insurancesAddress: [Keys] = [.name, .address, .country, .state, .city, .insurance_enable, .insurances, .custom_fields, .insurance_info]
    
    static let getPackages: [Keys] = [.type, .category_id, .list_by, .after]
    
    #if CloudDoc
    static let packageDetail: [Keys] = [.plan_id]
    #else
    static let packageDetail: [Keys] = [.package_id]
    #endif
    
    static let buyPackage: [Keys] = [.plan_id]
    
    static let getFeeds: [Keys] = [.type , .consultant_id, .after]
    
    static let addFav: [Keys] = [.favorite]
    
    static let addComment: [Keys] = [.comment]
    
    static let getQuestions: [Keys] = [.after]
    
    static let submitQuestion: [Keys] = [.title, .description, .package_id, .category_id]
    
    static let orderCreate: [Keys] = [.balance, .package_id, .payment_method, .lat, .long]
    
    static let razorPayWebhook: [Keys] = [.order_id, .razorpayPaymentId]
    
    static let symptoms: [Keys] = [.type, .symptom_id]
    
    static let updateRequestSymptoms: [Keys] = [.request_id, .option_ids, .symptom_details, .images]
    
    static let addWaterLimit: [Keys] = [.limit]
    
    static let drinkWater: [Keys] = [.quantity]
    
    static let addFamily: [Keys] = [.first_name, .last_name, .relation, .gender, .age, .height, .weight, .blood_group, .image, .optionals, .medical_allergies, .chronic_diseases, .previous_surgeries, .previous_medication, .country_code, .email, .phone, .patient_type, .chronic_diseases_desc]
    
    static let uploadMedia: [Keys] = [.type]
    
    static let hyperPayWebHook: [Keys] = [.resourcePath]
    
    static let masterPreferences: [Keys] = [.type]
    
    static let questionDetail: [Keys] = [.question_id]
    
    static let apptDetail: [Keys] = [.request_id]
    
    static let addBank: [Keys] = [.account_holder_name, .account_number, .bank_name, .bank_id]
    
    static let getMedicalHistory: [Keys] = [.request_id, .after]
    
    static let locationUpdate: [Keys] = [.lat, .long]
    
    static let vendorListV2: [Keys] = [.category_id, .service_id, .search, .service_type, .lat, .long, .address_id]
    static let createRequestV2: [Keys] = [.consultant_id, .date, .time, .service_id, .schedule_type, .coupon_code, .request_id, .lat, .long, .service_address, .second_oponion, .title, .images, .tier_id, .tier_options, .end_date, .end_time, .category_id]

}

