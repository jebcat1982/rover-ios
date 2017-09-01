//
//  UNUserNotificationCenter.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UserNotifications

public protocol UNUserNotificationCenterProtocol {
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void)
}

extension UNUserNotificationCenter: UNUserNotificationCenterProtocol { }
