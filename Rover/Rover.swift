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
    
    let application: UIApplication
    let eventManager: EventManager
    let httpClient: HTTPClient
    let notificationCenter: NotificationCenter
    
    public static func initialize(accountToken: String, logLevel: LogLevel = .warn) {
        logger.threshold = logLevel
        logger.warnUnlessMainThread("Rover must be initialized on the main thread")
        
        if sharedInstance != nil {
            logger.warn("Rover already initialized")
            return
        }
        
//        let rover = Rover()
//        rover.initialize(accountToken: accountToken)
//        sharedInstance = rover
    }
    
    init(application: UIApplication, eventManager: EventManager, httpClient: HTTPClient, notificationCenter: NotificationCenter) {
        self.application = application
        self.eventManager = eventManager
        self.httpClient = httpClient
        self.notificationCenter = notificationCenter
        
        notificationCenter.addObserver(forName: .UIApplicationDidFinishLaunching, object: application, queue: nil) { _ in
            self.launch()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidBecomeActive, object: application, queue: nil) { _ in
            self.activate()
        }
    }
    
    func initialize(accountToken: String) {
        // TODO: Add account token to HTTPClient
        // TODO: Restore profile identifier from user defaults
        // TODO: Capture static context
    }
    
    func launch() {
        // TODO: Check if app was updated or installed and track appropriate event
    }
    
    func activate() {
        // TODO: Track "Open App" event
        // TODO: Fetch state
    }
    
    public func anonymize() {
        // TODO: Remove profile identifier from http client
        // TODO: Remove profile identifier from user defaults
    }
    
    public func identify(_ identifier: String) {
        // TODO: Add profile identifier to http client
        // TODO: Add profile identifier to user defaults
    }
    
    public func addDeviceToken(_ data: Data) {
        // let pushToken = data.map { String(format: "%02.2hhx", $0) }.joined()
        
        // TODO: Add device token to event context
        // TODO: Add device token to user defaults
        // TODO: Check if device token has been added, removed or updated and track appropriate event
    }
    
    public func removeDeviceToken() {
        // TODO: Remove device token from event context
        // TODO: Remove device token from user defaults
        // TODO: Check if device token has been added, removed or updated and track appropriate event
    }
}
