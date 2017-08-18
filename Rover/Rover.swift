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
    
    var currentState = ApplicationState()
    var previousState = ApplicationState()
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
    func dispatch(_ operation: Operation)
    func dispatch(_ operation: Operation, completionHandler: ((ApplicationState, ApplicationState) -> Void)?)
}

extension Rover: Dispatcher {
    
    func dispatch(_ operation: Operation) {
        dispatch(operation, completionHandler: nil)
    }
    
    func dispatch(_ operation: Operation, completionHandler: ((ApplicationState, ApplicationState) -> Void)?) {
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
    func reduce(block: (ApplicationState) -> ApplicationState)
}

extension Rover: Reducer {
    
    func reduce(block: (ApplicationState) -> ApplicationState) {
        logger.warnIfMainThread("reduce should only be called from within the execute method of an Operation")
        previousState = currentState
        currentState = block(currentState)
    }
}

// MARK: Resolver

protocol Resolver {
    var currentState: ApplicationState { get }
    var previousState: ApplicationState { get }
}

extension Rover: Resolver { }

// MARK: OperationDelegate

extension Rover: OperationDelegate {
    
    func calculateDepth(_ operation: Operation) -> Int {
        var depth = 0
        var child = operation
        while let parent = child.delegate as? Operation {
            depth += 1
            child = parent
        }
        return depth
    }
    
    func log(_ operation: Operation, message: String) {
        let depth = calculateDepth(operation)
        let padding = String(repeating: " ", count: depth * 4)
        logger.debug(padding + message)
    }
    
    func operationDidStart(_ operation: Operation) {
        let name = operation.name ?? "Unknown"
        log(operation, message: "\(name) {")
    }
    
    func operationDidCancel(_ operation: Operation) {
        log(operation, message: "cancelled")
    }
    
    func operationDidFinish(_ operation: Operation) {
        log(operation, message: "}")
    }
}

// MARK: RoverEvents

public protocol RoverEvents {
    func trackEvent(name: String, attributes: Attributes?)
    func flushEvents()
    func configureEventQueue(flushAt: Int?, maxBatchSize: Int?, maxQueueSize: Int?)
}

extension Rover: RoverEvents {
    
    public static var events: RoverEvents {
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

// MARK: RoverExperiences {

public protocol RoverExperiences {
    func fetch(experienceID: ID, completionHandler: ((Experience?) -> Void)?)
}

extension Rover: RoverExperiences {
    
    public static var experiences: RoverExperiences {
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

// MARK: RoverPush

public protocol RoverPush {
    func addDeviceToken(_ data: Data)
    func removeDeviceToken()
}

extension Rover: RoverPush {
    
    public static var push: RoverPush {
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

// MARK: RoverSync

public protocol RoverSync {
    func now(completionHandler: (() -> Void)?)
}

extension Rover: RoverSync {
    
    public static var sync: RoverSync {
        return shared
    }
    
    public func now(completionHandler: (() -> Void)?) {
        let operation = SyncOperation()
        dispatch(operation) { (previousState, currentState) in
            completionHandler?()
        }
    }
}

// MARK: RoverProfile

public protocol RoverProfile {
    var current: Profile { get }
    
    func anonymize()
    func identify(profileID: ID)
    func updateProfile(attributes: Attributes, completionHandler: (() -> Void)?)
}

extension Rover: RoverProfile {
    
    static var profile: RoverProfile {
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

// MARK: RoverUX

public protocol RoverUX {
    
    
}

extension Rover: RoverUX {
    
    static var ux: RoverUX {
        return shared
    }
}
