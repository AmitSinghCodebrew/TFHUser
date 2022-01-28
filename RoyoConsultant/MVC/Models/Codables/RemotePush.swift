//
//  RemotePush.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 16/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class RemotePush: Codable {
    var messageType: String?
    var sentAt: String?
    var googleCAE: String?
    var receiverId: String?
    var message: String?
    var request_id: String?
    var aps: APS?
    var sender_name: String?
    var senderId: String?
    var googleCSenderId: String?
    var pushType: PushType?
    var vendor_category_name: String?
    var request_time: String?
    var sender_image: String?
    var senderName: String?
    var service_type: String?
    var call_id: String?

    private enum CodingKeys: String, CodingKey {
        case googleCAE = "google.c.a.e"
        case googleCSenderId = "google.c.sender.id"
        case messageType
        case sentAt
        case receiverId
        case message
        case request_id
        case aps
        case sender_name
        case senderId
        case pushType
        case vendor_category_name
        case request_time
        case sender_image
        case senderName
        case service_type
        case call_id
    }
}

final class APS: Codable {
    var alert: AlertNotification?
    var badge: Int?
    var sound: String?
}

final class AlertNotification: Codable {
    var body: String?
    var title: String?
}

enum PushType: String, CaseIterableDefaultsLast, Codable {
    case chat
    case REQUEST_ACCEPTED
    case REQUEST_COMPLETED
    case CALL_CANCELED
    case CALL_ACCEPTED
    case CALL_RINGING
    case CALL //PushKit
    case CANCELED_REQUEST
    case AMOUNT_DEDCUTED
    case BOOKING_RESERVED
    case AMOUNT_RECEIVED
    case REQUEST_FAILED
    case BALANCE_FAILED
    case BALANCE_ADDED
    case CHAT_STARTED
    case STARTED_REQUEST
    case START_SERVICE
    case COMPLETED
    case REACHED
    case START
    case CANCEL_SERVICE
    case QUESTION_ANSWERED
    case ASKED_QUESTION
    case PRESCRIPTION_ADDED
    case UPCOMING_APPOINTMENT
    case REQUEST_EXTRA_PAYMENT

    
    case UNKNOWN
}


