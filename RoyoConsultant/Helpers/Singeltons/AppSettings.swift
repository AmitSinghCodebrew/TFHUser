//
//  AppSettings.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 21/05/21.
//  Copyright © 2021 SandsHellCreations. All rights reserved.
//

import UIKit


enum CategoryImageAlign {
    case Left
    case Right
}

final class AppSettings {

    public static var categoryImageAlign: CategoryImageAlign {
        get {
            #if HealthCarePrashant || Heal
            return .Left
            #else
            return .Right
            #endif
        }
    }
    
    public static var mainCategoryTextColor: UIColor {
        #if TaraDoc
        return ColorAsset.txtMoreDark.color
        #else
        return ColorAsset.txtWhite.color
        #endif
    }
    
    public static var subCategoryCellID: String {
        #if HomeDoctorKhalid || TaraDoc
        return SubCategoryCenterCell.identfier
        #else
        return SubCategoryCell.identfier
        #endif
    }
    
    public static var isLocationEnabled: Bool {
        get {
            #if Heal || HealthCarePrashant || HealthCarePrashant || HomeDoctorKhalid || AirDoc || RoyoConsult || CloudDoc || TaraDoc
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var showBalanceOnTabScreens: Bool {
        get {
            #if HomeDoctorKhalid
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var showNotificationBtnOnHome: Bool {
        get {
            #if HomeDoctorKhalid
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var showClassesInSecondTab: Bool {
        get {
            #if Heal || HealthCarePrashant || HomeDoctorKhalid || AirDoc || NurseLynx || RoyoConsult || TaraDoc || CloudDoc
            return false
            #else
            return true
            #endif
        }
    }
    
    public static var showAddPatient: Bool {
        get {
            #if Heal
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var showBlogsOnHomeScreen: Bool {
        get {
            #if RoyoConsult || CloudDoc
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var showArticlesOnHomeScreen: Bool {
        get {
            #if Heal || RoyoConsult
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var showHealthTools: Bool {
        get {
            #if Heal || RoyoConsult
            return true
            #else
            return false
            #endif
        }
    }
    public static var showFreeQuestionsOnHomeScreen: Bool {
        get {
            #if HealthCarePrashant
            return true
            #else
            return false
            #endif
        }
    }
    
    public static var homeScreenServices: [CustomService] {
        get {
            #if RoyoConsult
            return [CustomService.init(#imageLiteral(resourceName: "ic_home_visit"), .HOME_VISIT, .home_visit),
                    CustomService.init(#imageLiteral(resourceName: "ic_conult_online"), .CONSULT_ONLINE, .consult_online),
                    CustomService.init(#imageLiteral(resourceName: "ic_online_programs"), .ONLINE_PROGRAMS, .online_programs),
                    CustomService.init(#imageLiteral(resourceName: "ic_free_advice"), .FREE_EXPERT_ADVICE, .free_expert_advice)]
            #elseif HomeDoctorKhalid
            //        CustomService.init(#imageLiteral(resourceName: "ic_emergency"), .EMERGENCY_APPT, .emergency)
            return [CustomService.init(#imageLiteral(resourceName: "ic_conult_online"), .CONSULT_ONLINE, .consult_online),
                    CustomService.init(#imageLiteral(resourceName: "ic_home_visit"), .HOME_VISIT, .home_visit),
                    CustomService.init(#imageLiteral(resourceName: "ic_clinic_appt"), .CLINIC_APPT, .clinic_visit)]
            
            #elseif Heal
            return [CustomService.init(#imageLiteral(resourceName: "ic_home_visit"), .HOME_VISIT, .home_visit),
                    CustomService.init(#imageLiteral(resourceName: "ic_conult_online"), .CONSULT_ONLINE, .consult_online),
                    CustomService.init(#imageLiteral(resourceName: "ic_online_programs"), .ONLINE_PROGRAMS, .online_programs),
                    CustomService.init(#imageLiteral(resourceName: "ic_emergency"), .EMERGENCY_APPT, .emergency),
                    CustomService.init(#imageLiteral(resourceName: "ic_free_advice"), .FREE_EXPERT_ADVICE, .free_expert_advice)]
            #else
            return [CustomService]()
            #endif
        }
    }
    
    public static var showTestimonialsOnHomeScreen: Bool {
        get {
            #if Heal
            return true
            #else
            return false
            #endif
        }
    }
}
