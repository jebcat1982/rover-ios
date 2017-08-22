//
//  Rover.swift
//  Rover
//
//  Created by Sean Rucker on 2017-03-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation
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
        rover.initialize(accountToken: accountToken)
        sharedInstance = rover
    }
    
    let serialQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    let pulseInterval: Double
    let application: UIApplicationProtocol
    let notificationCenter: NotificationCenterProtocol
    
    var currentState = ApplicationState()
    var previousState = ApplicationState()
    var backgroundTask = UIBackgroundTaskInvalid
    var pulseTimer: Timer?
    
    init(pulseInterval: Double = 30.0, application: UIApplicationProtocol = UIApplication.shared, notificationCenter: NotificationCenterProtocol = NotificationCenter.default) {
        self.pulseInterval = pulseInterval
        self.application = application
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(forName: .UIApplicationDidFinishLaunching, object: application, queue: nil) { _ in
            self.launch()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidBecomeActive, object: application, queue: nil) { _ in
            self.startPulseTimer()
            self.activate()
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
    
    func initialize(accountToken: String) {
        let operations = [
            AddAccountTokenToCredentialsOperation(accountToken: accountToken),
            AddDeviceIdentifierToCredentialsOperation(),
            RestoreProfileIdentifierFromUserDefaultsOperation(),
            CaptureContextOperation()
        ]
        operations.forEach(dispatch)
    }
    
    func launch() {
        let operation = TrackAppUpdateOperation()
        dispatch(operation)
    }
    
    func activate() {
        let operation = TrackEventOperation(eventName: "Open App", attributes: nil)
        dispatch(operation)
        
        performSync()
    }
    
    func performSync() {
        let operation = SyncOperation()
        dispatch(operation) { (previousState, currentState) in
            if currentState.profile != previousState.profile {
                let userInfo = [
                    "previousProfile": previousState.profile,
                    "currentProfile": currentState.profile
                ]
                self.notificationCenter.post(name: .RoverDidUpdateProfile, object: self, userInfo: userInfo)
            }
            
            if currentState.regions != previousState.regions {
                let userInfo = [
                    "previousRegions": previousState.regions,
                    "currentRegions": currentState.regions
                ]
                self.notificationCenter.post(name: .RoverDidUpdateRegions, object: self, userInfo: userInfo)
            }
        }
    }
    
    func flushEvents() {
        let operation = FlushEventsOperation(minBatchSize: 1)
        dispatch(operation)
    }
    
    func startPulseTimer() {
        stopPulseTimer()
        
        serialQueue.addOperation {
            guard self.pulseInterval > 0.0 else {
                return
            }
            
            let timer = Timer(timeInterval: self.pulseInterval, repeats: true) { _ in
                self.flushEvents()
                self.performSync()
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
    
    func indent(depth: Int) -> String {
        return String(repeating: " ", count: depth * 4)
    }
    
    func indentedMessage(_ message: String, operation: Operation) -> String {
        let depth = calculateDepth(operation)
        return indent(depth: depth) + message
    }
    
    func bulletedMessage(_ message: String, operation: Operation) -> String {
        return indentedMessage("  • " + message, operation: operation)
    }
    
    func operationDidStart(_ operation: Operation) {
        let newline = indentedMessage("", operation: operation)
        logger.debug(newline)
        
        let name = operation.name ?? "Unknown"
        let message = indentedMessage("\(name) {", operation: operation)
        logger.debug(message)
    }
    
    func operationDidCancel(_ operation: Operation) {
        let message = indentedMessage("cancelled", operation: operation)
        logger.debug(message)
    }
    
    func operationDidFinish(_ operation: Operation) {
        let message = indentedMessage("}", operation: operation)
        logger.debug(message)
    }
    
    func debug(_ message: String, operation: Operation) {
        let message = bulletedMessage(message, operation: operation)
        logger.debug(message)
    }
    
    func warn(_ message: String, operation: Operation) {
        let message = logger.threshold == .debug ? bulletedMessage(message, operation: operation) : message
        logger.warn(message)
    }
    
    func error(_ message: String, operation: Operation) {
        let message = logger.threshold == .debug ? bulletedMessage(message, operation: operation) : message
        logger.error(message)
    }
}

// MARK: RoverData

public protocol RoverData {
    func configure(baseURL: URL?, path: String?, session: URLSession?)
    
    func configure(baseURL: URL, path: String)
    func configure(baseURL: URL, session: URLSession)
    func configure(path: String, session: URLSession)
    
    func configure(baseURL: URL)
    func configure(path: String)
    func configure(session: URLSession)
}

extension Rover: RoverData {
    
    public static var data: RoverData {
        return shared
    }
    
    public func configure(baseURL: URL?, path: String?, session: URLSession?) {
        let operation = ConfigureDataClientOperation(baseURL: baseURL, path: path, session: session)
        dispatch(operation)
    }
    
    public func configure(baseURL: URL, path: String) {
        configure(baseURL: baseURL, path: path, session: nil)
    }
    
    public func configure(baseURL: URL, session: URLSession) {
        configure(baseURL: baseURL, path: nil, session: session)
    }
    
    public func configure(path: String, session: URLSession) {
        configure(baseURL: nil, path: path, session: session)
    }
    
    public func configure(baseURL: URL) {
        configure(baseURL: baseURL, path: nil, session: nil)
    }
    
    public func configure(path: String) {
        configure(baseURL: nil, path: path, session: nil)
    }
    
    public func configure(session: URLSession) {
        configure(baseURL: nil, path: nil, session: session)
    }
}

// MARK: RoverEvents

public protocol RoverEvents {
    func track(name: String, attributes: Attributes?)
    func track(name: String)
    func flush()
    func configure(flushAt: Int?, maxBatchSize: Int?, maxQueueSize: Int?)
}

extension Rover: RoverEvents {
    
    public static var events: RoverEvents {
        return shared
    }
    
    public func configure(flushAt: Int? = nil, maxBatchSize: Int? = nil, maxQueueSize: Int? = nil) {
        let operation = ConfigureEventQueueOperation(flushAt: flushAt, maxBatchSize: maxBatchSize, maxQueueSize: maxQueueSize)
        dispatch(operation)
    }
    
    public func flush() {
        flushEvents()
    }
    
    public func track(name: String, attributes: Attributes? = nil) {
        let operation = TrackEventOperation(eventName: name, attributes: attributes)
        dispatch(operation)
    }
    
    public func track(name: String) {
        track(name: name, attributes: nil)
    }
}

// MARK: RoverExperiences {

public protocol RoverExperiences {
    func fetch(experienceID: ID, completionHandler: @escaping (Experience?) -> Void)
    func find(experienceID: ID, completionHandler: @escaping (Experience?) -> Void)
}

extension Rover: RoverExperiences {
    
    public static var experiences: RoverExperiences {
        return shared
    }
    
    public func find(experienceID: ID, completionHandler: @escaping (Experience?) -> Void) {
        let operation = FindExperienceOperation(experienceID: experienceID)
        dispatch(operation) { (previousState, currentState) in
            let experience = currentState.experiences[experienceID]
            completionHandler(experience)
        }
    }
    
    public func fetch(experienceID: ID, completionHandler: @escaping (Experience?) -> Void) {
        let operation = FetchExperienceOperation(experienceID: experienceID)
        dispatch(operation) { (previousState, currentState) in
            let experience = currentState.experiences[experienceID]
            completionHandler(experience)
        }
    }
}

// MARK: RoverLocation

public protocol RoverLocation {
    func trackVisit(_ visit: CLVisit)
    func trackEnterRegion(_ region: CLRegion)
    func trackExitRegion(_ region: CLRegion)
    func trackUpdateLocations(_ locations: [CLLocation])
}

extension Rover: RoverLocation {
    
    public static var location: RoverLocation {
        return shared
    }
    
    public func trackVisit(_ visit: CLVisit) {
        let operation = TrackVisitOperation(visit: visit)
        dispatch(operation)
    }
    
    public func trackEnterRegion(_ region: CLRegion) {
        let operation = TrackEnterRegionOperation(region: region)
        dispatch(operation)
    }
    
    public func trackExitRegion(_ region: CLRegion) {
        let operation = TrackExitRegionOperation(region: region)
        dispatch(operation)
    }
    
    public func trackUpdateLocations(_ locations: [CLLocation]) {
        let operation = TrackUpdateLocationsOperation(locations: locations)
        dispatch(operation)
    }
}

// MARK: RoverProfile

public protocol RoverProfile {
    var current: Profile { get }
    
    func anonymize()
    func identify(_ identifier: String)
    func update(attributes: Attributes, completionHandler: (() -> Void)?)
}

extension Rover: RoverProfile {
    
    public static var profile: RoverProfile {
        return shared
    }
    
    public var current: Profile {
        return currentState.profile
    }
    
    public func anonymize() {
        let operation = AnonymizeOperation()
        dispatch(operation)
    }
    
    public func identify(_ identifier: String) {
        let operation = IdentifyOperation(identifier: identifier)
        dispatch(operation)
    }
    
    public func update(attributes: Attributes, completionHandler: (() -> Void)?) {
        let operation = UpdateProfileOperation(attributes: attributes)
        dispatch(operation) { (previousState, currentState) in
            completionHandler?()
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
    func now()
}

extension Rover: RoverSync {
    
    public static var sync: RoverSync {
        return shared
    }
    
    public func now() {
        performSync()
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
