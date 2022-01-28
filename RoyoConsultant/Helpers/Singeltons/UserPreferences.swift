//
//  UserPreferences.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 13/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class IQView: UIView {
    
}

final class UserPreference {
    
    private let DEFAULTS_KEY = "PROJECT_APP_USER"
    private let SETTINGS_KEY = "PROJECT_APP_SETTINGS_USER"
    private let INTRO_SCREENS_KEY = "INTRO_SCREENS_KEY"
    private let LANAGUGE_SCREEN_KEY = "LANAGUGE_SCREEN_KEY"
    private let CHOOSE_APP_KEY =  "CHOOSE_APP_KEY"
    private let MASTER_PREFERENCES_KEY = "MASTER_PREFERENCES_KEY"
    private let LOCATION_SCREEN_KEY = "LOCATION_SCREEN_KEY"

    static let shared = UserPreference()
    
    private init() {
        
    }
    
    var isUserLoggedIn: Bool {
        get {
            return !(/data?.token == "" || /data?.name == "")
        }
    }
        
    var isGradientViews: Bool {
        get {
            #if TaraDoc
            return true
            #else
            return false
            #endif
        }
    }
    
    var gradientColors: [UIColor] {
        get {
            #if TaraDoc
            return [ColorAsset.Gradient0.color, ColorAsset.Gradient1.color]
            #else
            return []
            #endif
        }
    }
    
    var data : User? {
        get{
            return fetchData(key: DEFAULTS_KEY)
        }
        set{
            if let value = newValue {
                saveData(value, key: DEFAULTS_KEY)
            } else {
                removeData(key: DEFAULTS_KEY)
            }
        }
    }
    
    var isChooseAppScreenShown: Bool? {
        get {
            #if Heal || HealthCarePrashant
            return fetchData(key: CHOOSE_APP_KEY)
            #else
            return true
            #endif
        }
        set {
            if let value = newValue {
                saveData(value, key: CHOOSE_APP_KEY)
            } else {
                removeData(key: CHOOSE_APP_KEY)
            }
        }
    }
    
    var isLocationScreenSeen: Bool? {
        get {
            #if HealthCarePrashant || Heal || RoyoConsult || TaraDoc
            return fetchData(key: LOCATION_SCREEN_KEY)
            #else
            return true
            #endif
        }
        set {
            if let value = newValue {
                saveData(value, key: LOCATION_SCREEN_KEY)
            } else {
                removeData(key: LOCATION_SCREEN_KEY)
            }
        }
    }
    
    var isIntroScreensSeen: Bool? {
        get {
            #if Heal || HealthCarePrashant
            return fetchData(key: INTRO_SCREENS_KEY)
            #else
            return true
            #endif
        }
        set {
            if let value = newValue {
                saveData(value, key: INTRO_SCREENS_KEY)
            } else {
                removeData(key: INTRO_SCREENS_KEY)
            }
        }
    }
    
    var isLanguageScreenShown: Bool? {
        get {
            #if Heal || HomeDoctorKhalid
            return fetchData(key: LANAGUGE_SCREEN_KEY)
            #else
            return true
            #endif
        }
        set {
            if let value = newValue {
                saveData(value, key: LANAGUGE_SCREEN_KEY)
            } else {
                removeData(key: LANAGUGE_SCREEN_KEY)
            }
        }
    }
    
    var masterPrefs: [Filter]? {
        get {
            return fetchData(key: MASTER_PREFERENCES_KEY)
        }
        set {
            if let value = newValue {
                saveData(value, key: MASTER_PREFERENCES_KEY)
            } else {
                removeData(key: MASTER_PREFERENCES_KEY)
            }
        }
    }
    
    var dateFormat: String {
        get {
            return "MMM dd, yyyy"
        }
    }
    
    var clientDetail : ClientDetail? {
        get{
            return fetchData(key: SETTINGS_KEY)
        }
        set{
            if let value = newValue {
                saveData(value, key: SETTINGS_KEY)
            } else {
                removeData(key: SETTINGS_KEY)
            }
        }
    }
    
    public var firebaseToken: String?
    
    public var VOIP_TOKEN: String? {
        didSet {
            if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: false) {
                EP_Home.updateFCMId.request(success: { (_) in
                    
                })
            }
        }
    }
        
    public var didAddedOrModifiedBooking: Bool = false
    
    public var pages: [Page]?
    
    public var socialLoginData: GoogleAppleFBUserData?
    
    public func getCurrencyAbbr() -> String {
        let localeID = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : /UserPreference.shared.clientDetail?.currency])
        let locale = Locale.init(identifier: localeID)
        return /locale.currencySymbol
    }
    
    //MARK:- Generic function used anywhere directly copy it
    private func saveData<T: Codable>(_ value: T, key: String) {
        
        guard let data = JSONHelper<T>().getData(model: value) else {
            removeData(key: key)
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func fetchData<T: Codable>(key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        return JSONHelper<T>().getCodableModel(data: data)
    }
    
    private func removeData(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
