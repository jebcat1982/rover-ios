//
//  AddNotificationSettingsToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UserNotifications

class AddNotificationSettingsToContextOperation: ContainerOperation {
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
                
                switch settings.authorizationStatus {
                case .authorized:
                    nextContext.notificationAuthorization = "authorized"
                case .denied:
                    nextContext.notificationAuthorization = "denied"
                case .notDetermined:
                    nextContext.notificationAuthorization = "notDetermined"
                }
                
                var nextState = state
                nextState.context = nextContext
                return nextState
            }
            
            completionHandler()
        }
    }
}
