//
//  ProfileItem.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 02/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//


import UIKit

class ProfileItem {
    var title: VCLiteral?
    var image: UIImage?
    var page: Page?
    
    init(_ _title: VCLiteral, _ _image: UIImage?) {
        title = _title
        image = _image
    }
    
    init(_ _page: Page?, _image: UIImage?) {
        page = _page
        image = _image
    }
    
    class func getItems(pages: [Page]?) -> [ProfileItem] {
        

        var items = [ProfileItem.init(.ACCOUNT_SETTINGS, #imageLiteral(resourceName: "ic_setting")),
                     ProfileItem.init(.CHANGE_PASSWORD, #imageLiteral(resourceName: "ic_password")),
                     ProfileItem.init(.CHANGE_LANGUAGE, #imageLiteral(resourceName: "ic_language")),
                     ProfileItem.init(.HISTORY, #imageLiteral(resourceName: "ic_history")),
                     ProfileItem.init(.NOTIFICATIONS, #imageLiteral(resourceName: "ic_notification_drawer")),
                     ProfileItem.init(.INVITE_PEOPLE, #imageLiteral(resourceName: "ic_invite_drawer"))]
        
        items.append(ProfileItem.init(.PACAKAGES, #imageLiteral(resourceName: "ic_packages")))
        pages?.forEach({ items.append(ProfileItem.init($0, _image: #imageLiteral(resourceName: "ic_info")))})
        
        
        #if HomeDoctorKhalid
        items.insert(ProfileItem.init(.BANK_DETAILS, #imageLiteral(resourceName: "ic_bank")), at: 1)
        #endif
        
        if UserPreference.shared.data?.provider_type != .email {
            items.removeAll(where: {$0.title == .CHANGE_PASSWORD})
        }
        
        var newArray = items// + [ProfileItem.init(.PACAKAGES, #imageLiteral(resourceName: "ic_packages"))]
        
        #if Heal || HomeDoctorKhalid
        newArray.removeAll(where: {$0.title == .PACAKAGES})
        #elseif NurseLynx || TaraDoc
        newArray.removeAll(where: { $0.title == .PACAKAGES || $0.title == .CHANGE_LANGUAGE })
        #elseif HealthCarePrashant
        newArray.removeAll(where: {
            $0.title == .PACAKAGES || $0.title == .HISTORY || $0.title == .ACCOUNT_SETTINGS || $0.title == .CHANGE_LANGUAGE
        })
        newArray.append(ProfileItem.init(.SECOND_OPINION, #imageLiteral(resourceName: "ic_packages")))
        #elseif CloudDoc
        newArray.insert(ProfileItem.init(.IDCARD, #imageLiteral(resourceName: "ic_card")), at: 1)
        newArray.removeAll(where: { $0.title == .CHANGE_LANGUAGE || $0.title == .SECOND_OPINION })
        #else
        
        #endif
        
        if /UserPreference.shared.clientDetail?.support_url != "" {
            newArray.append(ProfileItem.init(.SUPPORT, #imageLiteral(resourceName: "ic_info")))
        }
        
        return newArray + [ProfileItem.init(.LOGOUT, #imageLiteral(resourceName: "ic_logout"))]
    }
}
