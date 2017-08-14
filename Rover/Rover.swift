//
//  Rover.swift
//  Rover
//
//  Created by Sean Rucker on 2017-03-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

public class Rover: ApplicationContainer {
    static var sharedInstance: Rover?
    
    let serialQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    let pulseInterval: Double
    let application: UIApplicationProtocol
    
    var currentState = ContainerState()
    var previousState = ContainerState()
    var backgroundTask = UIBackgroundTaskInvalid
    var pulseTimer: Timer?
    
    init(pulseInterval: Double = 30.0, application: UIApplicationProtocol = UIApplication.shared, notificationCenter: NotificationCenterProtocol = NotificationCenter.default) {
        self.pulseInterval = pulseInterval
        self.application = application
        
        observeApplicationNotifications(notificationCenter: notificationCenter)
    }
}

extension Rover {
    
    @discardableResult public static func assemble(accountToken: String) -> Rover {
        let rover = Rover()
        sharedInstance = rover
        return rover
    }
    
    static var shared: Rover {
        guard let sharedInstance = sharedInstance else {
            fatalError("Shared instance accessed before calling assemble")
        }
        
        return sharedInstance
    }
}

// MARK: Application LifeCycle

extension Rover {
    
//    override func applicationDidBecomeActive() {
//        let timestamp = Date()
//        let operations = [
//            TrackEventOperation(eventName: "App Opened", attributes: nil, timestamp: timestamp),
//            SyncOperation()
//        ]
//        let group = ContainerOperation(operations: operations)
//        dispatch(group)
//    }
    
//    override func applicationDidPulse() {
//        let operation = FlushEventsOperation(minBatchSize: 1)
//
//    }
    
//    public func applicationDidPulse() -> ContainerOperation? {
//        return FlushEventsOperation(minBatchSize: 1)
//    }
    
//    public func applicationDidEnterBackground() -> ContainerOperation? {
//        return FlushEventsOperation(minBatchSize: 1)
//    }
}

// MARK: Events

public protocol Events {
    
    func trackEvent(name: String, attributes: Attributes?)
}

extension Rover: Events {
    
    public static var events: Events {
        return shared
    }
    
    public func trackEvent(name: String, attributes: Attributes? = nil) {
//        container.trackEvent(name: name, attributes: attributes)
    }
}

// MARK: Push

public protocol Push {
    
    func addDeviceToken(_ data: Data)
    
    func removeDeviceToken()
}

extension Rover: Push {
    
    public static var push: Push {
        return shared
    }
    
    public func addDeviceToken(_ data: Data) {
//        container.addDeviceToken(data: data)
    }
    
    public func removeDeviceToken() {
//        container.removeDeviceToken()
    }
}

// MARK: Sync

public protocol Sync {
    
    func sync(completionHandler: (() -> Void)?)
}

extension Rover: Sync {
    
    public static var sync: Sync {
        return shared
    }
    
    public func sync(completionHandler: (() -> Void)?) {

    }
}

// MARK: Profile

extension Rover {
    
//    public var current: Profile {
//        return container.resolve(DataPlugin.self).profile
//    }
//    
//    public func anonymize() {
//        container.anonymize()
//    }
//    
//    public func identify(profileID: ID) {
//        container.identify(profileID: profileID)
//    }
//    
//    public func updateProfile(attributes: Attributes, completionHandler: ((Profile) -> Void)?) {
//        container.updateProfile(attributes: attributes)
//    }
}

