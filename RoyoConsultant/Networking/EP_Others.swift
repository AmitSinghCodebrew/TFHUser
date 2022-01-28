//
//  EP_Others.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 15/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import Moya

enum EP_Others {
    
    case vendorListV2(categoryId: Int?, service_id: Int?, search: String?, serviceType: ServiceType?, lat: String?, long: String?, address_id: String?)
    case createRequest(consultant_id: String?, date: String?, time: String?, service_id: String?, schedule_type: ScheduleType, coupon_code: String?, request_id: String?, latitude: Double?, longitude: Double?, service_address: String?, secondOpinion: Bool?, title: String?, images: String?, tier_id: Int?, tier_options: Any?, end_date: String?, end_time: String?, category_id: String?)
    case confirmRequest(consultant_id: String?, date: String?, time: String?, service_id: String?, schedule_type: ScheduleType, coupon_code: String?, request_id: String?, latitude: Double?, longitude: Double?, service_address: String?, secondOpinion: Bool?, title: String?, images: String?, tier_id: Int?, tier_options: Any?, end_date: String?, end_time: String?, category_id: String?)

}

extension EP_Others: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        return URL.init(string: Configuration.getValue(for: .PROJECT_BASE_PATH))!
    }
    
    var path: String {
        switch self {
        case .vendorListV2:
            return APIConstants.vendorListV2
        case .createRequest:
            return APIConstants.createRequestV2
        case .confirmRequest:
            return APIConstants.confirmRequestV2
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .vendorListV2:
            return .get
            
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        
        switch self {
        case .vendorListV2(let categoryId, let service_id, let search, let serviceType, let lat, let long, let address_id):
            
            return Parameters.vendorListV2.map(values: [categoryId, service_id, search, serviceType?.rawValue, lat, long, address_id])
        case .createRequest(let consultant_id, let date, let time, let service_id, let schedule_type, let coupon_code, let request_id, let latitude, let longitude, let serviceAddress, let secondOpinion, let title, let images, let tierId, let tierOptions, let end_date, let end_time, let category_id):
            return Parameters.createRequestV2.map(values: [consultant_id, date, time, service_id, schedule_type.rawValue, coupon_code, request_id, latitude, longitude, serviceAddress, secondOpinion, title, images, tierId, tierOptions, end_date, end_time, category_id])
            
        case .confirmRequest(let consultant_id, let date, let time, let service_id, let schedule_type, let coupon_code, let request_id, let latitude, let longitude, let serviceAddress, let secondOpinion, let title, let images, let tierId, let tierOptions, let end_date, let end_time, let category_id):
            return Parameters.createRequestV2.map(values: [consultant_id, date, time, service_id, schedule_type.rawValue, coupon_code, request_id, latitude, longitude, serviceAddress, secondOpinion, title, images, tierId, tierOptions, end_date, end_time, category_id])
       
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        //        case .uploadImage:
        //            return Task.uploadMultipart(multipartBody ?? [])
        default:
            return Task.requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        //        case .:
        //            return ["Accept" : "application/json",
        //                    "devicetype": "IOS",
        //                    "app-id": Configuration.getValue(for: .PROJECT_PROJECT_ID),
        //                    "timezone": NSTimeZone.local.identifier,
        //                    "user-type": UserType.customer.rawValue,
        //                    "language" : L102Language.currentAppleLanguage() == .Arabic ? "ar" : "en"]
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
        case .vendorListV2:
            return URLEncoding.queryString
            
        default:
            return JSONEncoding.default
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        var multiPartData = [MultipartFormData]()
        switch self {
        //        case .uploadImage(let image, let mediaType, let doc, let localAudioPath):
        //            switch mediaType {
        //            case .image:
        //                let data = image.jpegData(compressionQuality: 0.5) ?? Data()
        //                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: "image.jpg", mimeType: "image/jpeg"))
        //            case .pdf:
        //                let data = doc?.data ?? Data()
        //                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: /doc?.fileName, mimeType: "application/pdf"))
        //            case .audio:
        //                let fileName = /localAudioPath?.split(separator: "/").last?.lowercased()
        //                guard let data = try? Data.init(contentsOf: URL.init(string: /localAudioPath)!) else {
        //                    return multiPartData
        //                }
        //                multiPartData.append(MultipartFormData.init(provider: .data(data), name: Keys.image.rawValue, fileName: fileName, mimeType: "audio/m4a"))
        //            }
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

