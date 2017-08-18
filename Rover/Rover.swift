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
            fatalError("Rover accessed before calling initialize")
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
        
        notificationCenter.addObserver(forName: .UIApplicationDidBecomeActive, object: application, queue: nil) { _ in
            self.startPulseTimer()
            
            let operation = ActivateOperation()
            self.dispatch(operation)
        }
        
        notificationCenter.addObserver(forName: .UIApplicationWillResignActive, object: application, queue: nil) { _ in
            self.stopPulseTimer()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidEnterBackground, object: application, queue: nil) { _ in
            self.beginBackgroundTask()
            self.flushEvents()
            self.endBackgroundTask()
        }
    }
    
    func startPulseTimer() {
        stopPulseTimer()
        
        serialQueue.addOperation {
            guard self.pulseInterval > 0.0 else {
                return
            }
            
            let timer = Timer(timeInterval: self.pulseInterval, repeats: true) { _ in
                self.flushEvents()
            }
            
            DispatchQueue.main.async {
                RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
            }
            
            self.pulseTimer = timer
        }
    }
    
    func stopPulseTimer() {
        serialQueue.addOperation {
            guard let pulseTimer = self.pulseTimer else {
                return
            }
            
            DispatchQueue.main.async {
                pulseTimer.invalidate()
            }
            
            self.pulseTimer = nil
        }
    }
    
    func beginBackgroundTask() {
        endBackgroundTask()
        
        serialQueue.addOperation {
            self.backgroundTask = self.application.beginBackgroundTask() {
                self.serialQueue.cancelAllOperations()
                self.endBackgroundTask()
            }
        }
    }
    
    func endBackgroundTask() {
        serialQueue.addOperation {
            if (self.backgroundTask != UIBackgroundTaskInvalid) {
                self.application.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = UIBackgroundTaskInvalid
            }
        }
    }
}

// MARK: Dispatcher

protocol Dispatcher {
    func dispatch(_ operation: ContainerOperation)
    func dispatch(_ operation: ContainerOperation, completionHandler: ((ContainerState, ContainerState) -> Void)?)
}

extension Rover: Dispatcher {
    
    func dispatch(_ operation: ContainerOperation) {
        dispatch(operation, completionHandler: nil)
    }
    
    func dispatch(_ operation: ContainerOperation, completionHandler: ((ContainerState, ContainerState) -> Void)?) {
        logger.warnUnlessMainThread("dispatch should only be called from the main thread")
        operation.delegate = self
        operation.reducer = self
        operation.resolver = self
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                completionHandler?(self.previousState, self.currentState)
            }
        }
        
        serialQueue.addOperation(operation)
    }
}

// MARK: Reducer

protocol Reducer {    
    func reduce(block: (ContainerState) -> ContainerState)
}

extension Rover: Reducer {
    
    func reduce(block: (ContainerState) -> ContainerState) {
        logger.warnIfMainThread("reduce should only be called from within the execute method of a ContainerOperation")
        previousState = currentState
        currentState = block(currentState)
    }
}

// MARK: Resolver

protocol Resolver {
    var currentState: ContainerState { get }
    var previousState: ContainerState { get }
}

extension Rover: Resolver { }

// MARK: ContainerOperationDelegate

extension Rover: ContainerOperationDelegate {
    
    func calculateDepth(_ operation: ContainerOperation) -> Int {
        var depth = 0
        var child = operation
        while let parent = child.delegate as? ContainerOperation {
            depth += 1
            child = parent
        }
        return depth
    }
    
    func log(_ operation: ContainerOperation, message: String) {
        let depth = calculateDepth(operation)
        let padding = String(repeating: " ", count: depth * 4)
        logger.debug(padding + message)
    }
    
    func operationDidStart(_ operation: ContainerOperation) {
        let name = operation.name ?? "Unknown"
        log(operation, message: "\(name) {")
    }
    
    func operationDidCancel(_ operation: ContainerOperation) {
        log(operation, message: "cancelled")
    }
    
    func operationDidFinish(_ operation: ContainerOperation) {
        log(operation, message: "}")
    }
}

// MARK: EventsContainer

public protocol EventsContainer {
    func trackEvent(name: String, attributes: Attributes?)
    func flushEvents()
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
    
    public func flushEvents() {
        let operation = FlushEventsOperation(minBatchSize: 1)
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
