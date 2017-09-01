//
//  Rover.swift
//  Rover
//
//  Created by Sean Rucker on 2017-03-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation
import CoreTelephony
import UIKit
import UserNotifications

// TODO: Replace HTTPSession and HTTPTask with protocol shims
// TODO: Remove TrackAppUpdateOperation
// TODO: Rename EventManager to EventsManager
// TODO: Create an assembler so the default wiring can be customized
// TODO: Create an application events factory
// TODO: Figure out how UI can be notified of state changes

extension URLSession: HTTPSession {
    
    public func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping UploadTaskHandler) -> HTTPTask {
        return (uploadTask(with: request, from: bodyData, completionHandler: completionHandler) as URLSessionUploadTask) as HTTPTask
    }
}

extension URLSessionUploadTask: HTTPTask { }

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
        
        let endpoint = URL(string: "https://api.rover.io/")!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let device = UIDevice.current
        let httpClient = HTTPClient(accountToken: accountToken, endpoint: endpoint, session: session, device: device)
        
        let application = UIApplication.shared
        
        let applicationBundle = Bundle.main
        
        let locale = Locale.current
        let notificationCenter = NotificationCenter.default
        let screen = UIScreen.main
        let userNotificationCenter = UNUserNotificationCenter.current()
        
        let telephonyNetworkInfo = CTTelephonyNetworkInfo()
        let carrier = telephonyNetworkInfo.subscriberCellularProvider
        
        let timeZone = NSTimeZone.local as NSTimeZone
        
        var staticContextProviders: [ContextProvider] = [
            ApplicationContextProvider(bundle: applicationBundle),
            DeviceContextProvider(device: device),
            ScreenContextProvider(screen: screen)
        ]
        
        if let frameworkBundle = Bundle(identifier: "io.rover.Rover") {
            let frameworkContextProvider = FrameworkContextProvider(bundle: frameworkBundle)
            staticContextProviders.append(frameworkContextProvider)
        } else {
            logger.warn("Framework bundle not found")
        }
        
        var dynamicContextProviders: [ContextProvider] = [
            LocaleContextProvider(locale: locale),
            LocationContextProvider(locationManagerType: CLLocationManager.self),
            NotificationsContextProvider(notificationCenter: userNotificationCenter),
            TelephonyContextProvider(telephonyNetworkInfo: telephonyNetworkInfo, carrier: carrier),
            TimeZoneContextProvider(timeZone: timeZone)
        ]
        
        if let reachability = Reachability(hostname: "google.com") {
            let reachabilityContextProvider = ReachabilityContextProvider(reachability: reachability)
            dynamicContextProviders.append(reachabilityContextProvider)
        } else {
            logger.warn("Failed to initialize Reachability client")
        }
        
        let eventsConfiguration: EventsConfiguration = EventsConfiguration(minBatchSize: 20, maxBatchSize: 100, maxQueueSize: 1000, flushInterval: 30.0)
        let eventManager = EventManager(configuration: eventsConfiguration, staticContextProviders: staticContextProviders, dynamicContextProviders: dynamicContextProviders, application: application, httpClient: httpClient, notificationCenter: notificationCenter)
        
        let rover = Rover(application: application, eventManager: eventManager, httpClient: httpClient, notificationCenter: notificationCenter)
        sharedInstance = rover
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
