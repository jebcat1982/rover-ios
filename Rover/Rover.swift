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
    
    static var shared: Rover {
        guard let sharedInstance = sharedInstance else {
            fatalError("Rover accessed before calling assemble")
        }
        
        return sharedInstance
    }
    
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

// MARK: Assemble

extension Rover {
    
    @discardableResult public static func assemble(accountToken: String) -> Rover {
        let rover = Rover()
        let operation = AssembleOperation(accountToken: accountToken)
        rover.dispatch(operation)
        sharedInstance = rover
        return rover
    }
}

// MARK: Application LifeCycle

extension Rover {
    
    func applicationDidBecomeActive() {
        let operation = ActivateOperation()
        dispatch(operation)
    }
    
    func applicationDidPulse() {
        let operation = FlushEventsOperation(minBatchSize: 1)
        dispatch(operation)
    }
    
    func applicationDidEnterBackground() {
        let operation = FlushEventsOperation(minBatchSize: 1)
        dispatch(operation)
    }
}

// MARK: EventsContainer

public protocol EventsContainer {
    func trackEvent(name: String, attributes: Attributes?)
    func configureEventQueue(flushAt: Int?, maxBatchSize: Int?, maxQueueSize: Int?)
}

extension Rover: EventsContainer {
    
    public static var events: EventsContainer {
        return shared
    }
    
    public func configureEventQueue(flushAt: Int? = nil, maxBatchSize: Int? = nil, maxQueueSize: Int? = nil) {
        let operation = ConfigureEventQueueOperation(flushAt: flushAt, maxBatchSize: maxBatchSize, maxQueueSize: maxQueueSize)
        dispatch(operation)
    }
    
    public func trackEvent(name: String, attributes: Attributes? = nil) {
        let timestamp = Date()
        let operation = TrackEventOperation(eventName: name, attributes: attributes, timestamp: timestamp)
        dispatch(operation)
    }
}

// MARK: PushContainer

public protocol PushContainer {
    func addDeviceToken(_ data: Data)
    func removeDeviceToken()
}

extension Rover: PushContainer {
    
    public static var push: PushContainer {
        return shared
    }
    
    public func addDeviceToken(_ data: Data) {
        let operation = AddPushTokenOperation(data: data)
        dispatch(operation)
    }
    
    public func removeDeviceToken() {
        let operation = RemovePushTokenOperation()
        dispatch(operation)
    }
}

// MARK: SyncContainer

public protocol SyncContainer {
    func now(completionHandler: (() -> Void)?)
}

extension Rover: SyncContainer {
    
    public static var sync: SyncContainer {
        return shared
    }
    
    public func now(completionHandler: (() -> Void)?) {
        let operation = SyncOperation()
        dispatch(operation) { (previousState, currentState) in
            completionHandler?()
        }
    }
}

// MARK: ProfileContainer

public protocol ProfileContainer {
    var current: Profile { get }
    
    func anonymize()
    func identify(profileID: ID)
    func updateProfile(attributes: Attributes, completionHandler: (() -> Void)?)
}

extension Rover: ProfileContainer {
    
    static var profile: ProfileContainer {
        return shared
    }
    
    public var current: Profile {
        return currentState.profile
    }
    
    public func anonymize() {
        let operation = AnonymizeOperation()
        dispatch(operation)
    }
    
    public func identify(profileID: ID) {
        let operation = IdentifyOperation(profileID: profileID)
        dispatch(operation)
    }
    
    public func updateProfile(attributes: Attributes, completionHandler: (() -> Void)?) {
        let operation = UpdateProfileOperation(attributes: attributes)
        dispatch(operation) { (previousState, currentState) in
            completionHandler?()
        }
    }
}
