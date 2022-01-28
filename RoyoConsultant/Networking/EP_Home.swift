//
//  EP_Home.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import Moya

enum EP_Home {
    case categories(parentId: String?, after: String?, per_page: Int?)
    case requests(date: String?, serviceType: ServiceType, after: String?, second_oponion: String?, status: RequestStatus?)
    case vendorList(categoryId: Int?, filterOptionIds: String?, service_id: Int?, search: String?, page: Int?, serviceType: ServiceType?, after: Int?)
    case vendorDetail(id: String?)
    case getFilters(categoryId: String?)
    case logout
    case banners
    case chatListing(after: String?)
    case chatMessages(requestId: String?, after: String?)
    case uploadImage(image: UIImage, type: MediaTypeUpload, doc: Document?, localAudioPath: String?)
    case endChat(requestId: String?)
    case transactionHistory(transactionType: TransactionType, after: String?)
    case wallet
    case cards
    case addCard(cardNumber: String?, expMonth: String?, expYear: String?, cvv: String?)
    case addMoney(balance: String?, cardId: String?)
    case createRequest(consultant_id: String?, date: String?, time: String?, service_id: String?, schedule_type: ScheduleType, coupon_code: String?, request_id: String?, latitude: Double?, longitude: Double?, service_address: String?, secondOpinion: Bool?, title: String?, images: String?, tier_id: Int?, tier_options: Any?, end_date: String?, end_time: String?)
    case notifications(after: String?)
    case classes(type: ClassType, categoryId: Int?, after: String?, vendorID: Int?)
    case services(categoryId: String?)
    case updateFCMId
    case addReview(consultantId: String?, requestId: String?, review: String?, rating: String?)
    case getReviews(vendorId: String?, after: String?)
    case deleteCard(cardId: String?)
    case updateCard(cardId: String?, name: String?, expMonth: String?, expYear: String?)
    case coupons(categoryId: String?, serviceId: String?)
    case confirmRequest(consultantId: String?, date: String?, time: String?, serviceId: String, scheduleType: ScheduleType, couponCode: String?, requestId: String?, tierId: Int?)
    case getSlots(vendorId: String?, date: String?, serviceId: String?, categoryId: String?)
    case enrollUser(classId: String?)
    case classJoin(classId: String?)
    case cancelRequest(requestId: String?, reason: String?)
    case makeCall(requestID: String?)
    case callStatus(requestID: String?, status: CallStatus, callId: String?)
    case appversion(app: AppType, version: String?)
    case pages
    case getClientDetail(app: AppType)
    case getCountryStateCity(type: CountryStateCity, countryId: Int?, stateId: Int?)
    case packages(type: PackageType, categoyId: Int?, listBy: ListBy, after: String?)
    case packageDetail(id: Int?)
    case buyPackage(planId: Int?)
    case getFeeds(feedType: FeedType?, consultant_id: Int?, after: String?)
    case addFav(feedId: Int?, favorite: CustomBool)
    case viewFeed(id: Int?)
    case home
    case addComment(id: Int?, comment: String?)
    case getComments(id: Int?)
    case addLike(id: Int?)
    case getQuestions(after: String?)
    case submitQuestion(title: String?, desc: String?, package_id: Int?, categoryId: Int?)
    case orderCreate(balance: String?, packageId: Int?, paymentMethod: HyperPayCardType?)
    case razorPayWebhook(order_id: String?, razorpayPaymentId: String?)
    case supportPackages(after: String?)
    case symptoms(type: SymptomType, symptomId: Int?)
    case updateRequestSymptoms(requestId: Int?, option_ids: String?, symptom_details: String?, images: Any?)
    case addWaterLimit(limit: String?)
    case getWaterLimit
    case drinkWater(qty: String?)
    case addFamily(firstName: String?, lastName: String?, relation: String?, gender: String?, age: String?, height: String?, weight: String?, blood_group: String?, image: String?, optionals: String?, medical_allergies: String?, chronic_diseases: String?, previous_surgeries: String?, previous_medication: String?, country_code: String?, email: String?, phone: String?, patient_type: PatientType, chronic_diseases_desc: String?)
    case addProteinLimit(limit: String?)
    case getProteinLimit
    case drinkProtein(qty: String?)
    case hyperPayWebHook(resource: String?)
    case masterPreferences(type: MasterPrefernceType)
    case questionDetail(questionId: Int?)
    case apptDetail(id: Int?)
    case payExtra(id: Int?)
    case notifyUser(id: Int?)
    case addBank(account_holder_name: String?, account_number: String?, bank_name: String?, bank_id: Int?)
    case banks
    case getMedicalHistory(request_id: Int?, after: String?)
    #if CloudDoc
    case subscriptions(after: String?)
    case addCarePlan(requestID: Int, care_plans: Any?, question_answers: Any?)
    #elseif NurseLynx
    case addCarePlan(requestID: Int, care_plans: Any?, question_answers: Any?)
    case tiers
    #endif
}

extension EP_Home: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL.init(string: Configuration.getValue(for: .PROJECT_BASE_PATH))!
    }
    
    var path: String {
        switch self {
        case .categories:
            return APIConstants.categories
        case .requests:
            return APIConstants.requests
        case .logout:
            return APIConstants.logout
        case .vendorList:
            return APIConstants.vendorList
        case .vendorDetail(_):
            return APIConstants.vendorDetail
        case .getFilters(_):
            return APIConstants.getFilters
        case .banners:
            return APIConstants.banners
        case .chatListing(_):
            return APIConstants.chatListing
        case .chatMessages(_, _):
            return APIConstants.chatMessages
        case .uploadImage:
            return APIConstants.uploadImage
        case .endChat(_):
            return APIConstants.endChat
        case .transactionHistory(_, _):
            return APIConstants.transactionHistory
        case .wallet:
            return APIConstants.wallet
        case .cards:
            return APIConstants.cards
        case .addCard(_, _, _, _):
            return APIConstants.addCard
        case .addMoney(_, _):
            return APIConstants.addMoney
        case .createRequest:
            return APIConstants.createRequest
        case .notifications(_):
            return APIConstants.notifications
        case .classes(_, _, _, _):
            return APIConstants.classes
        case .services(_):
            return APIConstants.services
        case .updateFCMId:
            return APIConstants.updateFCMId
        case .addReview(_, _, _, _):
            return APIConstants.addReview
        case .getReviews(_, _):
            return APIConstants.getReviews
        case .deleteCard(_):
            return APIConstants.deleteCard
        case .updateCard(_, _, _, _):
            return APIConstants.updateCard
        case .coupons(_, _):
            return APIConstants.coupons
        case .confirmRequest:
            return APIConstants.confirmRequest
        case .getSlots(_, _, _, _):
            return APIConstants.getSlots
        case .enrollUser(_):
            return APIConstants.enrollUser
        case .classJoin(_):
            return APIConstants.classJoin
        case .cancelRequest:
            return APIConstants.cancelRequest
        case .makeCall(_):
            return APIConstants.makeCall
        case .callStatus:
            return APIConstants.callStatus
        case .appversion(_, _):
            return APIConstants.appVersion
        case .pages:
            return APIConstants.pages
        case .getClientDetail(_):
            return APIConstants.clientDetail
        case .getCountryStateCity(_, _, _):
            return APIConstants.countryData
        case .packages(_, _, _, _):
            return APIConstants.packages
        case .packageDetail(_):
            return APIConstants.packageDetail
        case .buyPackage(_):
            return APIConstants.buyPackage
        case .getFeeds(_, _, _):
            return APIConstants.feeds
        case .addFav(let id, _):
            return "\(APIConstants.addFav)/\(/id)"
        case .viewFeed(let id):
            return "\(APIConstants.viewFeed)/\(/id)"
        case .home:
            return APIConstants.home
        case .addComment(let id, _):
            return "\(APIConstants.addComment)/\(/id)"
        case .getComments(let id):
            return "\(APIConstants.getComments)/\(/id)"
        case .addLike(let id):
            return "\(APIConstants.addLike)/\(/id)"
        case .getQuestions, .submitQuestion:
            return APIConstants.askQuestions
        case .orderCreate:
            return APIConstants.orderCreate
        case .razorPayWebhook:
            return APIConstants.razorPayWebhook
        case .supportPackages:
            return APIConstants.supportPackages
        case .symptoms:
            return APIConstants.symptoms
        case .updateRequestSymptoms:
            return APIConstants.updateRequestSymptoms
        case .addWaterLimit, .getWaterLimit:
            return APIConstants.waterLimit
        case .drinkWater:
            return APIConstants.drinkWater
        case .addProteinLimit, .getProteinLimit:
            return APIConstants.proteinLimit
        case .drinkProtein:
            return APIConstants.drinkProtein
        case .addFamily:
            return APIConstants.addFamily
        case .hyperPayWebHook:
            return APIConstants.hyperPayWebHook
        case .masterPreferences:
            return APIConstants.masterPreferences
        case .questionDetail:
            return APIConstants.questionDetail
        case .apptDetail:
            return APIConstants.apptDetail
        case .payExtra:
            return APIConstants.payExtra
        case .notifyUser:
            return APIConstants.notifyUser
        case .addBank:
            return APIConstants.addBank
        case .banks:
            return APIConstants.banks
        case .getMedicalHistory:
            return APIConstants.getMedicalHistory
        #if CloudDoc
        case .subscriptions:
            return APIConstants.subscriptions
        case .addCarePlan:
            return APIConstants.addCarePlan
        #elseif NurseLynx
        case .addCarePlan:
            return APIConstants.addCarePlan
        case .tiers:
            return APIConstants.tiers
        #endif
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categories,
             .requests,
             .vendorList,
             .vendorDetail(_),
             .getFilters(_),
             .banners,
             .chatListing(_),
             .chatMessages(_, _),
             .transactionHistory(_, _),
             .wallet,
             .cards,
             .notifications(_),
             .classes(_, _, _, _),
             .services(_),
             .getReviews(_, _),
             .coupons(_, _),
             .getSlots(_, _, _, _),
             .pages,
             .getClientDetail(_),
             .getCountryStateCity(_, _, _),
             .packages(_, _, _, _),
             .packageDetail(_),
             .getFeeds(_, _, _),
             .viewFeed(_),
             .home,
             .getComments,
             .getQuestions,
             .supportPackages,
             .symptoms,
             .getWaterLimit,
             .getProteinLimit,
             .masterPreferences,
             .questionDetail,
             .apptDetail,
             .banks,
             .getMedicalHistory:
            return .get
        #if CloudDoc
        case .subscriptions:
            return .get
        #elseif NurseLynx
        case .tiers:
            return .get
        #endif
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        let location = LocationManager.shared.locationData
        switch self {
        case .categories(let parentId, let after, let perPage):
            return Parameters.categories.map(values: [parentId, after, perPage])
        case .requests(let date, let serviceType, let after, let secondOpinion, let status):
            return Parameters.requests.map(values: [date, serviceType.rawValue, after, secondOpinion, status?.apiFilterValue])
        case .vendorList(let categoryId, let filterOptionIds, let service_id, let search, let page, let serviceType, let after):
            if AppSettings.isLocationEnabled {
                return Parameters.vendorList.map(values: [categoryId, filterOptionIds, service_id, search, page, 10, serviceType?.rawValue, /String(/location.latitude), /String(/location.longitude), after])
            } else {
                return Parameters.vendorList.map(values: [categoryId, filterOptionIds, service_id, search, page, 10, serviceType?.rawValue, nil, nil, after])
                
            }
        case .vendorDetail(let id):
            return Parameters.vendorDetail.map(values: [id])
        case .chatMessages(let requestId, let after):
            return Parameters.chatMessages.map(values: [requestId, after])
        case .endChat(let requestId):
            return Parameters.endChat.map(values: [requestId])
        case .transactionHistory(let type, let after):
            return Parameters.transactionHistory.map(values: [type.rawValue, after])
        case .addCard(let cardNumber, let expMonth, let expYear, let cvv):
            return Parameters.addCard.map(values: [cardNumber, expMonth, expYear, cvv])
        case .addMoney(let balance, let cardId):
            return Parameters.addMoney.map(values: [balance, cardId])
        case .createRequest(let consultant_id, let date, let time, let service_id, let schedule_type, let coupon_code, let request_id, let latitude, let longitude, let serviceAddress, let secondOpinion, let title, let images, let tierId, let tierOptions, let end_date, let end_time):
            return Parameters.createRequest.map(values: [consultant_id, date, time, service_id, schedule_type.rawValue, coupon_code, request_id, latitude, longitude, serviceAddress, secondOpinion, title, images, tierId, tierOptions, end_date, end_time])
        case .notifications(let after):
            return Parameters.notifications.map(values: [after])
        case .classes(let type, let categoryId, let after, let vendorID):
            return Parameters.classes.map(values: [type.rawValue, categoryId, after, vendorID])
        case .services(let categoryId):
            return Parameters.services.map(values: [categoryId])
        case .getFilters(let categoryId):
            return Parameters.getFilters.map(values: [categoryId])
        case .updateFCMId:
            var dict = Parameters.updateFCMId.map(values: [UserPreference.shared.firebaseToken])
            if /UserPreference.shared.VOIP_TOKEN != "" {
                dict?[Keys.apn_token.rawValue] = /UserPreference.shared.VOIP_TOKEN
            }
            return dict
        case .addReview(let consultantId, let requestId, let review, let rating):
            return Parameters.addReview.map(values: [consultantId, requestId, review, rating])
        case .getReviews(let vendorId, let after):
            return Parameters.getReviews.map(values: [vendorId, after])
        case .deleteCard(let cardId):
            return Parameters.deleteCard.map(values: [cardId])
        case .updateCard(let cardId, let name, let expMonth, let expYear):
            return Parameters.updateCard.map(values: [cardId, name, expMonth, expYear])
        case .coupons(let categoryId, let serviceId):
            return Parameters.coupons.map(values: [categoryId, serviceId])
        case .confirmRequest(let consultantId, let date, let time, let serviceId, let scheduleType, let couponCode, let requestId, let tierId):
            return Parameters.confirmRequest.map(values: [consultantId, date, time, serviceId, scheduleType.rawValue, couponCode, requestId, tierId])
        case .getSlots(let vendorId, let date, let serviceId, let categoryId):
            return Parameters.getSlots.map(values: [vendorId, date, serviceId, categoryId])
        case .enrollUser(let classId):
            return Parameters.enrollUser.map(values: [classId])
        case .classJoin(let classId):
            return Parameters.classJoin.map(values: [classId])
        case .cancelRequest(let requestId, let reason):
            return Parameters.cancelRequest.map(values: [requestId, reason])
        case .makeCall(let requestID):
            return Parameters.makeCall.map(values: [requestID])
        case .callStatus(let requestID, let status, let callId):
            return Parameters.callStatus.map(values: [requestID, status.rawValue, callId])
        case .chatListing(let after):
            return Parameters.chatListing.map(values: [after])
        case .appversion(let app, let version):
            return Parameters.appversion.map(values: [app.rawValue, version, "1"]) //1-IOS
        case .getClientDetail(let app):
            return Parameters.clientDetail.map(values: [app.rawValue])
        case .getCountryStateCity(let type, let countryId, let stateId):
            return Parameters.countryData.map(values: [type.rawValue, countryId, stateId])
        case .packages(let type, let categoyId, let listBy, let after):
            return Parameters.getPackages.map(values: [type.rawValue, categoyId, listBy.rawValue, after])
        case .packageDetail(let id):
            return Parameters.packageDetail.map(values: [id])
        case .buyPackage(let id):
            return Parameters.buyPackage.map(values: [id])
        case .getFeeds(let feedType, let consultant_id, let after):
            return Parameters.getFeeds.map(values: [feedType?.rawValue, consultant_id, after])
        case .addFav(_, let favorite):
            return Parameters.addFav.map(values: [/Int(favorite.rawValue)])
        case .addComment(_, let comment):
            return Parameters.addComment.map(values: [comment])
        case .getQuestions(let after):
            return Parameters.getQuestions.map(values: [after])
        case .submitQuestion(let title, let desc, let packageId, let categoryId):
            return Parameters.submitQuestion.map(values: [title, desc, packageId, categoryId])
        case .orderCreate(let balance, let packageId, let healPaymentType):
            #if Heal
            return Parameters.orderCreate.map(values: [balance, packageId, healPaymentType?.rawValue, location.latitude, location.longitude])
            #else
            return Parameters.orderCreate.map(values: [balance, packageId, nil, nil, nil])
            #endif
        case .razorPayWebhook(let order_id, let razorpayPaymentId):
            return Parameters.razorPayWebhook.map(values: [order_id, razorpayPaymentId])
        case .supportPackages(let after):
            return Parameters.getQuestions.map(values: [after])
        case .symptoms(let type, let symptomId):
            return Parameters.symptoms.map(values: [type.rawValue, symptomId])
        case .updateRequestSymptoms(let requestId, let option_ids, let symptom_details, let images):
            return Parameters.updateRequestSymptoms.map(values: [requestId, option_ids, symptom_details, images])
        case .addWaterLimit(let limit):
            return Parameters.addWaterLimit.map(values: [limit])
        case .drinkWater(let quantity):
            return Parameters.drinkWater.map(values: [quantity])
        case .addProteinLimit(let limit):
            return Parameters.addWaterLimit.map(values: [limit])
        case .drinkProtein(let quantity):
            return Parameters.drinkWater.map(values: [quantity])
        case .addFamily(let firstName, let lastName, let relation, let gender, let age, let height, let weight, let blood_group, let image, let optionals, let medical_allergies, let chronic_diseases, let previous_surgeries, let previous_medication, let country_code, let email, let phone, let patient_type, let chronic_diseases_desc):
            return Parameters.addFamily.map(values: [firstName, lastName, relation, gender, age, height, weight, blood_group, image, optionals, medical_allergies, chronic_diseases, previous_surgeries, previous_medication, country_code, email, phone, patient_type.rawValue, chronic_diseases_desc])
        case .uploadImage(_, type: let mediaType, _, _):
            return Parameters.uploadMedia.map(values: [mediaType.rawValue])
        case .hyperPayWebHook(let resource):
            return Parameters.hyperPayWebHook.map(values: [resource])
        case .masterPreferences(let type):
            return Parameters.masterPreferences.map(values: [type.rawValue])
        case .questionDetail(let questionId):
            return Parameters.questionDetail.map(values: [questionId])
        case .apptDetail(let id):
            return Parameters.apptDetail.map(values: [id])
        case .payExtra(let id):
            return Parameters.apptDetail.map(values: [id])
        case .notifyUser(let id):
            return Parameters.apptDetail.map(values: [id])
        case .addBank(let account_holder_name, let account_number, let bank_name, let bank_id):
            return Parameters.addBank.map(values: [account_holder_name, account_number, bank_name, bank_id])
        case .getMedicalHistory(let request_id, let after):
            return Parameters.getMedicalHistory.map(values: [request_id, after])
        #if CloudDoc
        case .subscriptions(let after):
            return Parameters.getQuestions.map(values: [after])
        case .addCarePlan(let requestID, let care_plans, let question_answers):
            var dict: [String : Any] = ["request_id": requestID, "type": "question_answers"]
            if let plans = care_plans {
                dict["care_plans"] = plans
            }
            if let questions = question_answers {
                dict["question_answers"] = questions
            }
            return dict
        #elseif NurseLynx
        case .addCarePlan(let requestID, let care_plans, _):
            var dict: [String : Any] = ["request_id": requestID]
            if let plans = care_plans {
                dict["care_plans"] = plans
            }
            return dict
        #endif
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .uploadImage:
            return Task.uploadMultipart(multipartBody ?? [])
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appversion(_, _),
             .pages,
             .getClientDetail(_),
             .masterPreferences:
            return ["Accept" : "application/json",
                    "devicetype": "IOS",
                    "app-id": Configuration.getValue(for: .PROJECT_PROJECT_ID),
                    "timezone": NSTimeZone.local.identifier,
                    "user-type": UserType.customer.rawValue,
                    "language" : L102Language.currentAppleLanguage() == .Arabic ? "ar" : "en"]
        default:
            return ["Accept" : "application/json",
                    "Authorization":"Bearer " + /UserPreference.shared.data?.token,
                    "devicetype": "IOS",
                    "app-id": Configuration.getValue(for: .PROJECT_PROJECT_ID),
                    "timezone": NSTimeZone.local.identifier,
                    "user-type": UserType.customer.rawValue,
                    "language" : L102Language.currentAppleLanguage() == .Arabic ? "ar" : "en"]
        }
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .categories,
             .requests,
             .vendorList,
             .vendorDetail(_),
             .getFilters(_),
             .banners,
             .chatListing(_),
             .chatMessages(_, _),
             .transactionHistory(_, _),
             .wallet,
             .cards,
             .notifications(_),
             .classes(_, _, _, _),
             .services(_),
             .getReviews(_, _),
             .coupons(_, _),
             .getSlots(_, _, _, _),
             .pages,
             .getClientDetail(_),
             .getCountryStateCity(_, _, _),
             .packages(_, _, _, _),
             .packageDetail(_),
             .getFeeds(_, _, _),
             .viewFeed(_),
             .home,
             .getComments,
             .getQuestions,
             .supportPackages,
             .symptoms,
             .getWaterLimit,
             .getProteinLimit,
             .masterPreferences,
             .questionDetail,
             .apptDetail,
             .banks,
             .getMedicalHistory:
            return URLEncoding.queryString
        #if CloudDoc
        case .subscriptions:
            return URLEncoding.queryString
        #elseif NurseLynx
        case .tiers:
            return URLEncoding.queryString
        #endif
        default:
            return JSONEncoding.default
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        var multiPartData = [MultipartFormData]()
        switch self {
        case .uploadImage(let image, let mediaType, let doc, let localAudioPath):
            switch mediaType {
            case .image:
                let data = image.jpegData(compressionQuality: 0.5) ?? Data()
                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: "image.jpg", mimeType: "image/jpeg"))
            case .pdf:
                let data = doc?.data ?? Data()
                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: /doc?.fileName, mimeType: "application/pdf"))
            case .audio:
                let fileName = /localAudioPath?.split(separator: "/").last?.lowercased()
                guard let data = try? Data.init(contentsOf: URL.init(string: /localAudioPath)!) else {
                    return multiPartData
                }
                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: fileName, mimeType: "audio/m4a"))
            }
        default: break
        }
        
        parameters?.forEach({ (key, value) in
            let tempValue = /(value as? String)
            let data = tempValue.data(using: String.Encoding.utf8) ?? Data()
            multiPartData.append(MultipartFormData.init(provider: .data(data), name: key))
        })
        return multiPartData
    }
    
}

