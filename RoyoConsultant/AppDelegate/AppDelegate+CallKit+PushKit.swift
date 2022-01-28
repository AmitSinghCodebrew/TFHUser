//
//  AppDelegate+CallKit+PushKit.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import UIKit
import PushKit
import CallKit

extension AppDelegate {
    //MARK:- PushKit Setup
    internal func VoIP_Registry() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
        providerDelegate = ProviderDelegate()
        useVoipToken(voipRegistry.pushToken(for: .voIP))
    }
    
    internal func useVoipToken(_ tokenData: Data?) {
        guard let token = tokenData else { return }
        UserPreference.shared.VOIP_TOKEN = token.reduce("", {$0 + String(format: "%02X", $1) })
        print("start voip")
        print(UserPreference.shared.VOIP_TOKEN)
        print("end voip")
        if checkUserLoggedIn(showPopUp: false) {
            EP_Home.updateFCMId.request(success: { (_) in
                
            })
        }
    }
}

//MARK:- PuskKit Delegates
extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        useVoipToken(pushCredentials.token)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        guard let dictionaryPayLoad = payload.dictionaryPayload as? [String : Any] else {
            return
        }
       
        let data = dictionaryPayLoad["data"] as? [String : Any]
        
        print(data)
        
        let requestID = String(/(data?["request_id"] as? Int))
        let handle = data?["sender_name"] as? String
        let isVideo = /(data?["service_type"] as? String)?.lowercased() == "video call"
   
        let tempCallId = "\(Configuration.getValue(for: .PROJECT_JITSI_SERVER))\(data?["call_id"] as? String ?? "")"
        print("call_id ::::::::::::")
        print(data?["call_id"] as? String ?? "" )
        callId =  tempCallId
        print(callId)
        
        providerDelegate?.displayIncomingCall(requestId: requestID, call_Id: callId, uuid: UUID(), handle: /handle, hasVideo: isVideo, completion: { (error) in
            Toast.shared.showAlert(type: .notification, message: /error?.localizedDescription)
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        })
    }
}

//MARK:- CALLKIT PROVIDER CXProvider
class ProviderDelegate: NSObject {
    
    private let provider: CXProvider
    var currentCallUUID: UUID?
    var requestId: String?
    var callID: String?
    var isVideo: Bool?
    
    override init() {
        provider = CXProvider(configuration: ProviderDelegate.providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = NSLocalizedString(Configuration.getValue(for: .PROJECT_APP_NAME), comment: "")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        
        providerConfiguration.supportsVideo = true
        
        providerConfiguration.maximumCallsPerCallGroup = 1
        
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        providerConfiguration.ringtoneSound = "call_sound.caf"
        
        providerConfiguration.iconTemplateImageData = #imageLiteral(resourceName: "logo_call").pngData()
        
        return providerConfiguration
    }
    
    func displayIncomingCall(requestId: String?, call_Id: String?, uuid: UUID, handle: String, hasVideo: Bool = true, completion: ((Error?) -> Void)?) {
        // 1.
        self.callID = call_Id
        self.requestId = requestId
        self.currentCallUUID = uuid
        self.isVideo = hasVideo
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        // 2.
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                
            }
            self.currentCallUUID = uuid
            // 4.
            completion?(error)
        }
        EP_Home.callStatus(requestID: /self.requestId, status: .CALL_RINGING, callId: self.callID).request(success: { (_) in
            
        }) { (_) in
            
        }
    }
    
    func endCall() {
        
        guard let uuid = currentCallUUID else {
            return
        }
        
        provider.reportCall(with: uuid, endedAt: Date(), reason: .remoteEnded)
        
        provider.invalidate()
        currentCallUUID = nil
        
    }
    
}

//MARK:- CXProvider Delegates
extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        DispatchQueue.main.async {
            EP_Home.callStatus(requestID: /self.requestId, status: .CALL_ACCEPTED, callId: self.callID).request(success: { (_) in
                
            }) { (_) in
                
            }
            ///UserPreference.shared.clientDetail?.getJitsiUniqueID(.CALL, id: /Int(/self.requestId))
            (UIApplication.shared.delegate as? AppDelegate)?.startJitsiCall(roomName:  self.callID ?? "", requestId: self.requestId, subject: VCLiteral.CALL.localized, isVideo: self.isVideo)
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        EP_Home.callStatus(requestID: requestId, status: .CALL_CANCELED, callId: callID).request(success: { (_) in
            
        }) { (_) in
            
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        EP_Home.callStatus(requestID: requestId, status: .CALL_CANCELED, callId: callID).request(success: { (_) in
            
        }) { (_) in
            
        }
        action.fulfill()
    }
}

