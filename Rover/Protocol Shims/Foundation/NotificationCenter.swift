//
//  NotificationCenter.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol NotificationCenterProtocol {
    
    @discardableResult func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> NSObjectProtocol
    
    func post(name aName: NSNotification.Name, object anObject: Any?)
    
    func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?)
}

extension NotificationCenter: NotificationCenterProtocol { }
