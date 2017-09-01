//
//  NotificationsContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UserNotifications

struct NotificationsContextProvider: ContextProvider {
    let notificationCenter: UNUserNotificationCenterProtocol
}

extension NotificationsContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        return context
//        notificationCenter.getNotificationSettings { settings in
//            var nextContext = context
//
//            let authorizationStatus: String
//            switch settings.authorizationStatus {
//            case .authorized:
//                authorizationStatus = "authorized"
//            case .denied:
//                authorizationStatus = "denied"
//            case .notDetermined:
//                authorizationStatus = "notDetermined"
//            }
//
//            logger.debug("Setting notificationAuthorization to: \(authorizationStatus)")
//            nextContext.notificationAuthorization = authorizationStatus
//
//            return nextContext
//        }
    }
}
