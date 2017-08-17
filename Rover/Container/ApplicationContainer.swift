//
//  ApplicationContainer.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol ApplicationContainer: Container {
    var pulseInterval: Double { get }
    var application: UIApplicationProtocol { get }
    var backgroundTask: UIBackgroundTaskIdentifier { get set }
    var pulseTimer: Timer? { get set }
    
    func applicationDidFinishLaunching(withOptions options: [UIApplicationLaunchOptionsKey: Any]?)
    func applicationDidBecomeActive()
    func applicationWillResignActive()
    func applicationDidEnterBackground()
    func applicationWillEnterForeground()
    func applicationWillTerminate()
    func applicationDidPulse()
}

// MARK: Application Notifications

extension ApplicationContainer {
    
    func observeApplicationNotifications(notificationCenter: NotificationCenterProtocol) {
        notificationCenter.addObserver(forName: .UIApplicationDidFinishLaunching, object: application, queue: nil) { notification in
            let options = notification.userInfo as? [UIApplicationLaunchOptionsKey: Any]
            self.applicationDidFinishLaunching(withOptions: options)
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidBecomeActive, object: application, queue: nil) { notification in
            self.startPulseTimer()
            self.applicationDidBecomeActive()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationWillResignActive, object: application, queue: nil) { notification in
            self.stopPulseTimer()
            self.applicationWillResignActive()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationDidEnterBackground, object: application, queue: nil) { notification in
            self.beginBackgroundTask()
            self.applicationDidEnterBackground()
            self.endBackgroundTask()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationWillEnterForeground, object: application, queue: nil) { notification in
            self.applicationWillEnterForeground()
        }
        
        notificationCenter.addObserver(forName: .UIApplicationWillTerminate, object: application, queue: nil) { notification in
            self.applicationWillTerminate()
        }
    }
    
    func applicationDidFinishLaunching(withOptions options: [UIApplicationLaunchOptionsKey: Any]?) { }
    
    func applicationDidBecomeActive() { }
    
    func applicationWillResignActive() { }
    
    func applicationDidEnterBackground() { }
    
    func applicationWillEnterForeground() { }
    
    func applicationWillTerminate() { }
    
    func applicationDidPulse() { }
}

// MARK: Pulse Timer

extension ApplicationContainer {
    
    func startPulseTimer() {
        stopPulseTimer()
        
        serialQueue.addOperation {
            guard self.pulseInterval > 0.0 else {
                return
            }
            
            let timer = Timer(timeInterval: self.pulseInterval, repeats: true) { _ in
                self.applicationDidPulse()
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
}

// MARK: Background Task

extension ApplicationContainer {
    
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
