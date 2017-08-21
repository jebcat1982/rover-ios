//
//  AddNotificationSettingsToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UserNotifications

class AddNotificationSettingsToContextOperation: Operation {
    let notificationCenter: UNUserNotificationCenterProtocol
    
    init(notificationCenter: UNUserNotificationCenterProtocol = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
        super.init()
        self.name = "Add Notification Settings To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        notificationCenter.getNotificationSettings { settings in
            reducer.reduce { state  in
                var nextContext = state.context
                
                let authorizationStatus: String
                switch settings.authorizationStatus {
                case .authorized:
                    authorizationStatus = "authorized"
                case .denied:
                    authorizationStatus = "denied"
                case .notDetermined:
                    authorizationStatus = "notDetermined"
                }
                
                self.delegate?.debug("Setting notificationAuthorization to: \(authorizationStatus)", operation: self)
                nextContext.notificationAuthorization = authorizationStatus
                
                var nextState = state
                nextState.context = nextContext
                return nextState
            }
            
            completionHandler()
        }
    }
}
