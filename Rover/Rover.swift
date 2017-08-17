//
//  Rover.swift
//  Rover
//
//  Created by Sean Rucker on 2017-03-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

public class Rover {
    static var sharedInstance: Rover?
    
    static var shared: Rover {
        guard let sharedInstance = sharedInstance else {
            fatalError("Rover accessed before calling assemble")
        }
        
        return sharedInstance
    }
    
    public static func initialize(accountToken: String, logLevel: LogLevel = .warn) {
        logger.threshold = logLevel
        logger.warnUnlessMainThread("Rover must be initialized on the main thread")
        
        if sharedInstance != nil {
            logger.warn("Rover already initialized")
            return
        }
        
        let rover = Rover()
        let operation = InitializeOperation(accountToken: accountToken)
        rover.dispatch(operation)
        sharedInstance = rover
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

// MARK: ApplicationContainer

extension Rover: ApplicationContainer {
    
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

extension Rover {
    
    
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

// MARK: ExperiencesContainer {

public protocol ExperiencesContainer {
    func fetch(experienceID: ID, completionHandler: ((Experience?) -> Void)?)
}

extension Rover: ExperiencesContainer {
    
    public static var experiences: ExperiencesContainer {
        return shared
    }
    
    public func find(experienceID: ID, completionHandler: ((Experience?) -> Void)?) {
        let operation = FindExperienceOperation(experienceID: experienceID)
        dispatch(operation) { (previousState, currentState) in
            let experience = currentState.experiences[experienceID]
            completionHandler?(experience)
        }
    }
    
    public func fetch(experienceID: ID, completionHandler: ((Experience?) -> Void)?) {
        let operation = FetchExperienceOperation(experienceID: experienceID)
        dispatch(operation) { (previousState, currentState) in
            let experience = currentState.experiences[experienceID]
            completionHandler?(experience)
        }
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

// MARK: UXCoordinator

public protocol UXCoordinator {
    
    
}

extension Rover: UXCoordinator {
    
    static var ux: UXCoordinator {
        return shared
    }
}
