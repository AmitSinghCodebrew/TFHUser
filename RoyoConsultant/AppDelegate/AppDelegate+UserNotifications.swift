//
//  AppDelegate+UserNotifications.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import Firebase

extension AppDelegate {
    internal func registerRemoteNotifications(_ app: UIApplication) {
      
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization( options: authOptions,completionHandler: {_, _ in })
        app.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    internal func handleAutomaticRefreshData(_ model: RemotePush?) {
        switch model?.pushType ?? .UNKNOWN {
        case .CALL:
            callId = model?.call_id
            break //PushKit handled
        case .CALL_CANCELED:
            if /callId == /model?.call_id {
                DispatchQueue.main.async {
                    self.pipViewCoordinator?.hide() { _ in
                        self.cleanUp()
                    }
                }
                onGoingCallRequestId = nil
                callId = nil
                providerDelegate?.endCall()
                Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            }
        case .CALL_RINGING, .CALL_ACCEPTED:
            //CASE NOT POSSIBLE BECAUSE CALL CAN BE INITIATED ONLY FROM VENDOR SIDE
            callId = model?.call_id
        case .REQUEST_ACCEPTED:
            
            #if NurseLynx
            
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
            } else if let apptsVC = UIApplication.topVC() as? ConfirmRequestPopVC {
                apptsVC.requestId = model?.request_id
                apptsVC.refreshViaNotification()
            } else {
                let destVC = Storyboard<ApptDetailVC>.Home.instantiateVC()
                destVC.requestID = Int(/model?.request_id)
                UIApplication.topVC()?.pushVC(destVC)
            }
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            
            #else
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
            }
            (UIApplication.topVC() as? ApptDetailVC)?.refreshViaNotification()
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)

            #endif
            
        case .REQUEST_COMPLETED,
             .CANCELED_REQUEST,
             .REQUEST_FAILED,
             .CHAT_STARTED,
             .STARTED_REQUEST,
             .REACHED,
             .COMPLETED,
             .START,
             .START_SERVICE,
             .CANCEL_SERVICE,
             .UPCOMING_APPOINTMENT,
             .REQUEST_EXTRA_PAYMENT:
           
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
            }
            (UIApplication.topVC() as? ApptDetailVC)?.refreshViaNotification()
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .chat:
            if /(UIApplication.topVC() as? ChatVC)?.thread?.id == /Int(/model?.request_id) {
                return
            } else if let chatListingVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[2] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: ChatListingVC.self)}) as? ChatListingVC {
                chatListingVC.reloadViaNotification()
            }
            let message = String.init(format: VCLiteral.NEW_MESSAGE.localized, /model?.senderName, /model?.aps?.alert?.body)
            Toast.shared.showAlert(type: .notification, message: message)
        case .AMOUNT_DEDCUTED, .AMOUNT_RECEIVED, .BOOKING_RESERVED:
            if /UIApplication.topVC()?.isKind(of: WalletVC.self) {
                (UIApplication.topVC() as? WalletVC)?.reloadViaNotification()
            }
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .BALANCE_ADDED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
            #if HomeDoctorKhalid || Heal
            
            #else
            UIApplication.topVC()?.dismiss(animated: true, completion: {
                UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
                UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
            })
            #endif
        case .BALANCE_FAILED:
            #if HomeDoctorKhalid || Heal
            
            #else
            UIApplication.topVC()?.dismissVC()
            #endif
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .QUESTION_ANSWERED:
            (UIApplication.topVC() as? QuestionDetailVC)?.questionDetailAPI()
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        case .UNKNOWN, .ASKED_QUESTION, .PRESCRIPTION_ADDED:
            Toast.shared.showAlert(type: .notification, message: /model?.aps?.alert?.body)
        }
    }
    
    internal func handleNotificationTap(_ model: RemotePush?) {
        switch model?.pushType ?? .UNKNOWN  {
        case .CALL:
            callId = model?.call_id
            break //PushKit handled
        case .CALL_CANCELED:
            if /callId == /model?.call_id {
                DispatchQueue.main.async {
                    self.pipViewCoordinator?.hide() { _ in
                        self.cleanUp()
                    }
                }
                onGoingCallRequestId = nil
                callId = nil
                providerDelegate?.endCall()
            }
        case .CALL_RINGING, .CALL_ACCEPTED:
            callId = model?.call_id
        //CASE NOT POSSIBLE BECAUSE CALL CAN BE INITIATED ONLY FROM VENDOR SIDE
        case .chat:
            if /UIApplication.topVC()?.isKind(of: ChatVC.self) {
                if /(UIApplication.topVC() as? ChatVC)?.thread?.id != /Int(/model?.request_id) {
                    //Refresh Chat Data for new vendor chat
                    (UIApplication.topVC() as? ChatVC)?.initialChatLoad()
                }
            } else {
                UIApplication.topVC()?.tabBarController?.selectedIndex = 2
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    (UIApplication.topVC() as? ChatListingVC)?.reloadViaNotification()
                }
                let destVC = Storyboard<ChatVC>.Home.instantiateVC()
                destVC.thread = ChatThread.init(model!)
                UIApplication.topVC()?.pushVC(destVC)
            }
        case .REQUEST_COMPLETED,
             .REQUEST_ACCEPTED,
             .CANCELED_REQUEST,
             .REQUEST_FAILED,
             .CHAT_STARTED,
             .STARTED_REQUEST,
             .REACHED,
             .COMPLETED,
             .START,
             .START_SERVICE,
             .CANCEL_SERVICE,
             .UPCOMING_APPOINTMENT,
             .REQUEST_EXTRA_PAYMENT:
            if let apptsVC = ((UIApplication.topVC()?.tabBarController?.viewControllers)?[1] as? UINavigationController)?.viewControllers.first(where: {$0.isKind(of: AppointmentsVC.self)}) as? AppointmentsVC {
                apptsVC.reloadViaNotification()
                UIApplication.topVC()?.tabBarController?.selectedIndex = 1
            }
            if /UIApplication.topVC()?.isKind(of: ApptDetailVC.self) && /(UIApplication.topVC() as? ApptDetailVC)?.request?.id == /Int(/model?.request_id) {
                (UIApplication.topVC() as? ApptDetailVC)?.refreshViaNotification()
            } else {
                let destVC = Storyboard<ApptDetailVC>.Home.instantiateVC()
                destVC.requestID = Int(/model?.request_id)
                UIApplication.topVC()?.pushVC(destVC)
            }
        case .AMOUNT_DEDCUTED, .AMOUNT_RECEIVED, .BOOKING_RESERVED, .ASKED_QUESTION:
            if /UIApplication.topVC()?.isKind(of: WalletVC.self) {
                (UIApplication.topVC() as? WalletVC)?.reloadViaNotification()
            } else {
                UIApplication.topVC()?.pushVC(Storyboard<WalletVC>.Home.instantiateVC())
            }
        case .BALANCE_ADDED:
            UIApplication.topVC()?.dismiss(animated: true, completion: {
                UIApplication.topVC()?.popTo(toControllerType: ConfirmBookingVC.self)
                UIApplication.topVC()?.popTo(toControllerType: WalletVC.self)
            })
        case .BALANCE_FAILED:
            UIApplication.topVC()?.dismissVC()
        case .QUESTION_ANSWERED:
            let destVC = Storyboard<QuestionDetailVC>.Home.instantiateVC()
            destVC.questionId = Int(/model?.request_id)
            UIApplication.topVC()?.pushVC(destVC)
        case .PRESCRIPTION_ADDED:
            let url = Configuration.getValue(for: .PROJECT_BASE_PATH) + APIConstants.pdf + "?request_id=\(/model?.request_id)&client_id=\(Configuration.getValue(for: .PROJECT_PROJECT_ID))&download"
            //for download --&download
            let destVC = Storyboard<WebLinkVC>.Home.instantiateVC()
            destVC.linkTitle = (url, VCLiteral.PRESC_DETAIL.localized)
            UIApplication.topVC()?.pushVC(destVC)
        case .UNKNOWN:
            break
        }
    }
}

//MARK:- UNUserNotificationCenter Deelgates
extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK:- Notification Native UI Tapped
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let userInfo = response.notification.request.content.userInfo as? [String : Any] else { return }
        let notificationData = JSONHelper<RemotePush>().getCodableModel(data: userInfo)
        handleNotificationTap(notificationData)
    }
    
    //MARK:- Native notification just came up
    internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let userInfo = notification.request.content.userInfo as? [String : Any] else { return }
        let notificationData = JSONHelper<RemotePush>().getCodableModel(data: userInfo)
        handleAutomaticRefreshData(notificationData)
    }
}

//MARK:- Firebase messaging delegate
extension AppDelegate: MessagingDelegate {
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserPreference.shared.firebaseToken = fcmToken
        
        if checkUserLoggedIn(showPopUp: false) {
            EP_Home.updateFCMId.request(success: { (_) in
                
            })
        }
    }
}
