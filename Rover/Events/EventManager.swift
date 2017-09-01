//
//  EventManager.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

public class EventManager {
    let application: UIApplicationProtocol
    let httpClient: HTTPClient
    let notificationCenter: NotificationCenterProtocol
    
    let staticContextProviders: [ContextProvider]
    let dynamicContextProviders: [ContextProvider]
    
    let flushInterval: Double
    let serialQueue: OperationQueue
    
    var backgroundTask = UIBackgroundTaskInvalid
    var timer: Timer?
    
    // The following vars must only be modified from an operation on the serial queue
    
    var context: Context = Context()
    var eventQueue: EventQueue
    var uploadTask: HTTPTask?
    
    public init(configuration: EventsConfiguration, staticContextProviders: [ContextProvider], dynamicContextProviders: [ContextProvider], application: UIApplicationProtocol, httpClient: HTTPClient, notificationCenter: NotificationCenterProtocol) {
        self.application = application
        self.httpClient = httpClient
        self.notificationCenter = notificationCenter
        
        self.staticContextProviders = staticContextProviders
        self.dynamicContextProviders = dynamicContextProviders
        
        self.flushInterval = configuration.flushInterval
        
        eventQueue = EventQueue(minBatchSize: configuration.minBatchSize, maxBatchSize: configuration.maxBatchSize, maxQueueSize: configuration.maxQueueSize)
        
        self.serialQueue = OperationQueue()
        serialQueue.maxConcurrentOperationCount = 1
        serialQueue.addOperation {
            self.captureContext()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidBecomeActive, object: application, queue: nil) { _ in
            self.startTimer()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationWillResignActive, object: application, queue: nil) { _ in
            self.stopTimer()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidEnterBackground, object: application, queue: nil) { _ in
            self.beginBackgroundTask()
            self.flushEvents()
            self.endBackgroundTask()
        }
    }
    
    public func track(event: Event) {
        serialQueue.addOperation {
            self.updateContext()
            self.addEvent(event)
            self.flushEvents()
        }
    }
    
    public func flushNow() {
        serialQueue.addOperation {
            self.flushEvents(minBatchSize: 1)
        }
    }
}

// MARK: Timer

extension EventManager {
    
    func startTimer() {
        stopTimer()
        
        serialQueue.addOperation {
            guard self.flushInterval > 0.0 else {
                return
            }
            
            let timer = Timer(timeInterval: self.flushInterval, repeats: true) { _ in
                self.flushEvents()
            }
            
            DispatchQueue.main.async {
                RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
            }
            
            self.timer = timer
        }
    }
    
    func stopTimer() {
        serialQueue.addOperation {
            guard let timer = self.timer else {
                return
            }
            
            DispatchQueue.main.async {
                timer.invalidate()
            }
            
            self.timer = nil
        }
    }
}

// MARK: Background task

extension EventManager {
    
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

// MARK: Operation Functions

/**
 * The following functions should only be called from an operation on the serial queue
 */
extension EventManager {
    
    func captureContext() {
        let contextProviders = staticContextProviders + dynamicContextProviders
        context = contextProviders.reduce(context, { $1.captureContext($0) })
    }
    
    func updateContext() {
        context = dynamicContextProviders.reduce(context, { $1.captureContext($0) })
    }
    
    func addEvent(_ event: Event) {
        eventQueue.addEvent(event, context: context, credentials: httpClient.credentials)
        persistEvents()
    }
    
    func persistEvents() {
        // TODO: Persist events
    }
    
    func flushEvents(minBatchSize: Int? = nil) {
        guard uploadTask == nil else {
            logger.debug("Skipping flush – upload already in progress")
            return
        }
        
        guard let batch = eventQueue.nextBatch(minBatchSize: minBatchSize) else {
            logger.debug("Skipping flush – less than \(minBatchSize ?? eventQueue.minBatchSize) events in the queue")
            return
        }
        
        logger.debug("Uploading \(batch.events.count) event(s) to server")
        
        uploadTask = httpClient.sendEventsTask(events: batch.events, context: batch.context, credentials: batch.credentials) { result in
            switch result {
            case let .error(error, shouldRetry):
                if let error = error {
                    logger.error(error.localizedDescription)
                }
                
                if shouldRetry {
                    logger.error("Failed to upload events - will retry")
                    self.serialQueue.addOperation {
                        self.flushEvents(minBatchSize: minBatchSize)
                    }
                } else {
                    logger.error("Failed to upload events - discarding events")
                    self.serialQueue.addOperation {
                        self.removeEvents(batch.events)
                    }
                }
            case .success:
                logger.debug("Successfully uploaded \(batch.events.count) event(s)")
                self.serialQueue.addOperation {
                    self.removeEvents(batch.events)
                }
            }
            
            self.uploadTask = nil
        }
        
        uploadTask!.resume()
    }
    
    func removeEvents(_ events: [Event]) {
        eventQueue.removeEvents(events)
        logger.debug("Removed \(events.count) event(s) from queue – queue now contains \(eventQueue.count) event(s)")
        persistEvents()
    }
}
