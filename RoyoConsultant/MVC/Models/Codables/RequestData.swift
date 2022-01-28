//
//  RequestData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class RequestData: Codable {
    var requests: [Requests]?
    var request_detail: Requests?
    var after: String?
    var before: String?
    
}

final class Requests: Codable {
    var id: Int?
    var from_user: User?
    var to_user: User?
    var booking_date: String?
    var bookingDateUTC: String?
    var canReschedule: Bool?
    var canCancel: Bool?
    var time: String?
    var service_type: String?
    var duration: Double?
    var status: RequestStatus?
    var price: Either<Double, String>?
    var schedule_type: ScheduleType?
    var service_id: Int?
    var main_service_type: String?
    var is_prescription: Bool?
    var symptoms: [Symptom]?
    var symptom_details: String?
    var symptom_images: [MediaObj]?
    var extra_detail: ExtraDetail?
    var second_oponion: SecondOpinion?
    var rating: Double?
    var service: Service?
    var extra_payment: ExtraPayment?
    var canNotify: Bool?
    var cancel_reason: String?
    
    #if CloudDoc
    var question_answers: [QuestionAnswer]?
    #elseif NurseLynx
    var tier_detail: Tier?
    #endif
    
    func getRelatedAction() -> RequestAction {
        switch /main_service_type?.lowercased() {
        case "audio_call":
            return .CALL
        case "video_call":
            return .VIDEO_CALL
        case "home_visit":
            return .HOME
        case "chat":
            return .CHAT
        default:
            return .DEFAULT
        }
    }
    
    public func isClinicAddress() -> Bool {
        return /main_service_type?.lowercased() == "clinic_visit"
    }
}

final class ExtraPayment: Codable {
    var balance: Double?
    var status: ExtraPaymentStatus?
    var description: String?
    var created_at: String?
}

final class ExtraDetail: Codable {
    var service_address: String?
    var lat: String?
    var long: String?
}

enum RequestAction {
    case CALL
    case VIDEO_CALL
    case CHAT
    case HOME
    case DEFAULT
}

final class SecondOpinion: Codable {
    var title: String?
    var images: String? //Multiple images , separated
    var record_type: String?
}
