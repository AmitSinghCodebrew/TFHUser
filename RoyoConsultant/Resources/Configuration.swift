//
//  Configuration.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/07/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

enum Configuration {
    
    enum ConfigKey: String {
        case PROJECT_CLIENT_ID
        case PROJECT_IMAGE_THUMBS
        case PROJECT_IMAGE_UPLOAD
        case PROJECT_IMAGE_ORIGINAL
        case PROJECT_BASE_PATH
        case PROJECT_SOCKET_BASE_PATH
        case PROJECT_JITSI_SERVER
        case PROJECT_APPLE_APP_ID
        case PROJECT_ANDROID_PACKAGE_NAME
        case PROJECT_FIREBASE_PAGE_LINK
        case PROJECT_BUNDLE_ID
        case PROJECT_PROJECT_ID
        case PROJECT_GOOGLE_PLIST
        case PROJECT_APP_NAME
        case PROJECT_GOOGLE_PLACES_KEY
        case PROJECT_PDF
        case PROJECT_AUDIO
        case PROJECT_LOCALIZABLE
        case RELATED_OTHER_APPLE_APP_ID
    }
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func appName() -> String {
        return NSLocalizedString(getValue(for: .PROJECT_APP_NAME), tableName: getValue(for: .PROJECT_LOCALIZABLE), comment: "")
    }
    
    private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
    
    static func getValue(for key: ConfigKey) -> String {
        return try! Configuration.value(for: key.rawValue)
    }
}
