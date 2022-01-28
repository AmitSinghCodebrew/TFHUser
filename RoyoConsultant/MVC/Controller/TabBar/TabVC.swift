//
//  TabVC.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 25/05/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit

class TabVC: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            // ios 13.0 and above
            let appearance = tabBar.standardAppearance
            appearance.shadowColor = nil
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)]
            
            tabBar.standardAppearance = appearance
        } else {
            // below ios 13.0
            let image = UIImage()
            tabBar.shadowImage = image
            tabBar.backgroundImage = image
            // background
            
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : Fonts.CamptonMedium.ofSize(10.0)], for: .selected)
        tabBar.layer.shadowColor = ColorAsset.shadow.color.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.masksToBounds = false
        tabBar.layer.borderColor = UIColor.clear.cgColor
        
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBar.items?[0].title = VCLiteral.TAB_HOME.localized
        tabBar.items?[1].title = VCLiteral.TAB_APPOINTMENT.localized
        tabBar.items?[2].title = VCLiteral.TAB_CHAT.localized
        tabBar.items?[3].title = VCLiteral.TAB_PROFILE.localized
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateNotificationTokens()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let indexTab: Int = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return
        }
        switch indexTab {
        case 0: //Home
            break //OK
        default: //Check if logged in or not
            if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: true) == false {
                self.selectedIndex = 0
            }
        }
    }
    
    func updateNotificationTokens() {
        if /UserPreference.shared.firebaseToken == "" {
            return
        }
        
        if /(UIApplication.shared.delegate as? AppDelegate)?.checkUserLoggedIn(showPopUp: false) {
            SocketIOManager.shared.connect(nil)
            EP_Home.updateFCMId.request(success: { (_) in
                SocketIOManager.shared.connect(nil)
            })
        }
    }
}
