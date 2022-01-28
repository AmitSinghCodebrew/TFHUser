//
//  Enums.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 18/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

enum MasterPrefernceType: String {
    case Languages
    case Gender
    case All
}

enum ProviderType: String, Codable, CaseIterableDefaultsLast{
    case facebook
    case google
    case email
    case phone
    case apple
    case updatePhone
    
    case unknown
}

enum VerifyType {
    case AccountCreation
    case HomeVisit(name: String, type: ServiceType)
}

enum UserType: String {
    case customer
    case service_provider
}

enum AppType: String {
    case UserApp = "1"
    case VendorApp = "2"
}

enum TransactionType: String, Codable, CaseIterableDefaultsLast {
    case deposit
    case withdrawal
    case refund
    case all
    case add_package
    case add_money
    case asked_question

    var transactionText: VCLiteral {
        switch self {
        case .withdrawal:
            return .MONEY_SENT_TO
        case .deposit, .add_money:
            return .ADDED_TO_WALLET
        case .refund:
            return .REFUND_FROM
        case .all:
            return .NA
        case .add_package:
            return .ADDED_PACKAGE
        case .asked_question:
            return .ASKED_A_QUESTION
        }
    }
}

enum ServiceType: String, Codable, CaseIterableDefaultsLast {
    case chat
    case call
    case home_visit
    case clinic_visit
    case emergency
    case free_expert_advice
    case tipOfTheDay
    case consult_online
    case online_programs
    case audio_call
    case video_call
    case all

    case unknown
    
    var title: VCLiteral {
        switch self {
        case .consult_online:
            return .CONSULT_ONLINE
        case .free_expert_advice:
            return .FREE_EXPERT_ADVICE
        case .tipOfTheDay:
            return .TIP_OF_THE_DAY
        case .emergency:
            return .EMERGENCY_APPT
        case .home_visit:
            return .HOME_VISIT
        case .chat:
            return .CHAT
        case .call, .audio_call:
            return .CALL
        case .online_programs:
            return .ONLINE_PROGRAMS
        case .clinic_visit:
            return .CLINIC_APPT
        default:
            return .CONSULT_DOCTOR
        }
    }
}

enum RequestStatus: String, Codable, CaseIterableDefaultsLast {
    case pending
    case inProgress = "in-progress"
    case accept
    case completed
    
    case noAnswer = "no-answer"
    case busy
    case failed
    case canceled
    case start
    case reached
    case start_service
    case cancel_service
    
    case unknown
    case all
    
    var linkedColor: ColorAsset {
        switch self {
        case .pending:
            return .requestStatusPending
        case .inProgress, .start, .reached:
            return .requestStatusInProgress
        case .start_service:
            return .requestStatusInProgress
        case .accept:
            return .requestStatusAccept
        case .completed:
            return .requestStatusCompleted
        case .noAnswer:
            return .requestStatusNoAnswer
        case .busy:
            return .requestStatusBusy
        case .failed, .canceled, .cancel_service:
            return .requestStatusFailed
        case .unknown, .all:
            return .appTint
        }
    }
    
    var title: VCLiteral {
        switch self {
        case .pending:
            return .NEW
        case .inProgress, .start:
            return .INPROGRESS
        case .reached:
            return .REACHED_DEST
        case .start_service:
            return .SERVICE_STARTED
        case .accept:
            return .ACCEPT
        case .completed:
            return .COMPLETE
        case .noAnswer:
            return .NO_ANSWER
        case .busy:
            return .BUSY
        case .failed:
            return .FAILED
        case .canceled, .cancel_service:
            return .CANCELLED
        case .unknown:
            return .NA
        case .all:
            return .ALL
        }
    }
    
    var apiFilterValue: String? {
        switch self {
        case .all:
            return nil
        case .pending:
            return "new"
        case .completed:
            return "completed"
        case .canceled:
            return "cancelled"
        default:
            return nil
        }
    }
}

extension String {
    var experience: String {
        if self == "1" {
            return String.init(format: VCLiteral.YR_EXP.localized, /self)
        } else if /self == "" {
            return ""
        } else {
            return String.init(format: VCLiteral.YRS_EXP.localized, /self)
        }
    }
}

enum AddMoneyAmounts: Int {
    case Amount1 = 500
    case Amount2 = 1000
    case Amount3 = 1500
    
    var formattedText: String {
        return "+ " + /Double(self.rawValue).getFormattedPrice()
    }
}

enum ScheduleType: String, Codable {
    case instant
    case schedule
}

enum ClassType: String, Codable, CaseIterableDefaultsLast {
    case USER_COMPLETED
    case USER_OCCUPIED
    case VENDOR_ADDED
    case VENDOR_COMPLETED
    case USER_SIDE
    case DEFAULT
}

enum CustomBool: String, Codable, CaseIterableDefaultsLast {
    case TRUE = "1"
    case FALSE = "0"
}

enum YesNo: String, Codable, CaseIterableDefaultsLast {
    case Yes
    case No
    
    var title: VCLiteral {
        switch self {
        case .Yes:
            return .YES
        case .No:
            return .NO
        }
    }
}
enum PriceType: String, Codable, CaseIterableDefaultsLast {
    case fixed_price
    case price_range
    
}

enum DiscountType: String, Codable, CaseIterableDefaultsLast {
    case currency
    case percentage
}

enum ClassStatus: String, Codable, CaseIterableDefaultsLast {
    case started
    case completed
    case added
    case Default
}

enum BannerType: String, Codable, CaseIterableDefaultsLast {
    case category = "category"
    case classs = "class"
    case service_provider = "service_provider"
}


enum CallStatus: String, Codable, CaseIterableDefaultsLast {
    case CALL_RINGING
    case CALL_ACCEPTED
    case CALL_CANCELED
}

enum CallType: String {
    case Incoming
    case Outgoing
}

enum CountryStateCity: String, Codable {
    case country
    case state
    case city
}

enum AppUpdateType: Int, Codable, CaseIterableDefaultsLast {
    case MajorUpdate = 2
    case MinorUpdate = 1
    case NoUpdate = 0
}

enum DynamicLinkPage: String {
    case userProfile
    case Invite
}

enum ListBy: String {
    case all
    case purchased
}

enum PackageType: String {
    case open
    case category
}

enum FeedType: String, CaseIterableDefaultsLast, Codable {
    case blog
    case article
    case na
    case faq
    case question
    
    var listingTitle: String {
        switch self {
        case .article:
            return VCLiteral.ARTICLES.localized
        case .blog:
            return VCLiteral.BlOGS.localized
        case .question:
            return VCLiteral.ASK_FREE_QUESTIONS.localized
        default:
            return ""
        }
    }
}

enum SymptomType: String {
    case symptom_category
    case symptom_options
    case all_symptom_options
}

enum MediaTypeUpload: String, Codable, CaseIterableDefaultsLast {
    case pdf = "PDF"
    case audio = "AUDIO"
    case image = "IMAGE"
}

enum HyperPayCardType: String {
    case Mada
    case visa_master
    
    var title: VCLiteral {
        switch self {
        case .Mada:
            return .HYPER_PAY_TYPE_MADA
        case .visa_master:
            return .HYPER_PAY_TYPE_MASTER_VISA
        }
    }
}

enum ExtraPaymentStatus: String, Codable {
    case pending
    case paid
    
    var title: VCLiteral {
        switch self {
        case .paid:
            return .EXTRA_PAYMENT_STATUS_PAID
        case .pending:
            return .EXTRA_PAYMENT_STATUS_PENDING
        }
    }
    
    var color: UIColor {
        switch self {
        case .paid:
            return ColorAsset.requestStatusCompleted.color
        case .pending:
            return ColorAsset.requestStatusFailed.color
        }
    }
}
