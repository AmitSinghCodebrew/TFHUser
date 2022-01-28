//
//  AppDelegate+JitsiMeet.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 22/06/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation
import JitsiMeetSDK

//MARK:- Jitsi start call functions for classes and calls
extension AppDelegate: JitsiMeetViewDelegate {
    
    public func startJitsiCall(roomName: String, requestId: String? = nil, subject: String?, isVideo: Bool?) {
        
        cleanUp()
        
        let user = UserPreference.shared.data
        
        onGoingCallRequestId = requestId
        
        print("roomName " + /roomName)
        print("roomServerURL " , "\(URL.init(string: Configuration.getValue(for: .PROJECT_JITSI_SERVER)))")
        
        // create and configure jitsimeet view
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = self
        self.jitsiMeetView = jitsiMeetView
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL.init(string: Configuration.getValue(for: .PROJECT_JITSI_SERVER))
            builder.room = roomName
            builder.welcomePageEnabled = false
            builder.userInfo = JitsiMeetUserInfo.init(displayName: /user?.name?.capitalizingFirstLetter(), andEmail: user?.email, andAvatar: URL.init(string: Configuration.getValue(for: .PROJECT_IMAGE_UPLOAD) + /user?.profile_image)!)
            builder.setFeatureFlag("invite.enabled", withValue: false)
            builder.setFeatureFlag("chat.enabled", withValue: false)
            builder.setFeatureFlag("calendar.enabled", withValue: false)
            builder.setFeatureFlag("call-integration.enabled", withValue: false)
            builder.setFeatureFlag("live-streaming.enabled", withValue: false)
            builder.setFeatureFlag("recording.enabled", withValue: false)
            builder.setFeatureFlag("tile-view.enabled", withValue: true)
            builder.setFeatureFlag("meeting-password.enabled", withValue: false)
            builder.setFeatureFlag("pip.enabled", withValue: true)
            builder.setFeatureFlag("close-captions.enabled", withValue: false)
            builder.setFeatureFlag("ios.screensharing.enabled", withValue: true)
            builder.setFeatureFlag("meeting-name.enabled", withValue: false)
            builder.subject = /subject
            //builder.audioOnly = false
            builder.audioMuted = false
            builder.videoMuted = !(/isVideo)
        }
        jitsiMeetView.join(options)
        // the view state and interactions
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.configureAsStickyView(withParentView: UIWindow.keyWindow?.subviews.last)
        
        // animate in
        jitsiMeetView.alpha = 0
        pipViewCoordinator?.show()
    }
    
    internal func cleanUp() {
        jitsiMeetView?.leave()
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
        pipViewCoordinator = nil
    }
    
    internal func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.hide() { _ in
                self.cleanUp()
            }
        }
        
        if let requestID = onGoingCallRequestId {
            providerDelegate?.endCall()
            EP_Home.callStatus(requestID: requestID, status: .CALL_CANCELED, callId: callId).request(success: { [weak self] (_) in
                self?.onGoingCallRequestId = nil
                self?.callId = nil
            }) { (_) in
                
            }
        } else {
            providerDelegate?.endCall()
        }
    }
    
    internal func enterPicture(inPicture data: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            self.pipViewCoordinator?.enterPictureInPicture()
        }
    }
}
