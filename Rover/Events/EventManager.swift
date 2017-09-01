//
//  EventManager.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

public class EventManager {
    let application: UIApplication
    let httpClient: HTTPClient
    let notificationCenter: NotificationCenter
    
    let flushInterval: Double
    let serialQueue: OperationQueue
    
    var backgroundTask = UIBackgroundTaskInvalid
    var timer: Timer?
    
    // The following vars must only be modified from an operation on the serial queue
    
    var context: Context = Context()
    var eventQueue: EventQueue
    var uploadTask: HTTPTask?
    
    public init(minBatchSize: Int = 20, maxBatchSize: Int = 100, maxQueueSize: Int = 1000, flushInterval: Double = 30.0, application: UIApplication, httpClient: HTTPClient, notificationCenter: NotificationCenter) {
        self.application = application
        self.httpClient = httpClient
        self.notificationCenter = notificationCenter
        
        self.flushInterval = flushInterval
        
        eventQueue = EventQueue(minBatchSize: minBatchSize, maxBatchSize: maxBatchSize, maxQueueSize: maxQueueSize)
        
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
            self.flushEvents()
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
//        AddApplicationInfoToContextOperation(),
//        AddDeviceInfoToContextOperation(),
//        AddSDKVersionToContextOperation(),
//        AddLocaleToContextOperation(),
//        AddLocationSettingsToContextOperation(),
//        AddNotificationSettingsToContextOperation(),
//        AddPushEnvironmentToContextOperation(),
//        AddScreenSizeToContextOperation(),
//        AddTelephonyInfoToContextOperation(),
//        AddTimeZoneToContextOperation(),
//        AddReachabilityInfoToContextOperation()
    }
    
    func updateContext() {
//        AddLocaleToContextOperation(),
//        AddLocationSettingsToContextOperation(),
//        AddNotificationSettingsToContextOperation(),
//        AddTelephonyInfoToContextOperation(),
//        AddTimeZoneToContextOperation(),
//        AddReachabilityInfoToContextOperation()
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

        let uploadTask = httpClient.sendEventsTask(events: batch.events, context: batch.context, credentials: batch.credentials) { result in
            switch result {
            case let .error(error, shouldRetry):
                if shouldRetry {
                    logger.error("Failed to upload events - will retry")
                    self.serialQueue.addOperation {
                        flushEvents(minBatchSize: minBatchSize)
                    }
                } else {
                    logger.error("Failed to upload events - discarding events")
                    serialQueue.addOperation {
                        removeEvents()
                    }
                }
            case .success:
                logger.debug("Successfully uploaded \(batch.events.count) event(s)")
                serialQueue.addOperation {
                    removeEvents()
                }
            }
            
            self.uploadTask = nil
        }
        
        uploadTask.resume()
        self.uploadTask = uploadTask
    }
    
    func removeEvents(_ events: [Event]) {
        eventQueue.removeEvents(events)
        logger.debug("Removed \(events.count) event(s) from queue – queue now contains \(eventQueue.count) event(s)")
        persistEvents()
    }
}
