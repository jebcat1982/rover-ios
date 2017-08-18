//
//  TrackAppUpdateOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class TrackAppUpdateOperation: Operation {
    let timestamp: Date
    let userDefaults: UserDefaultsProtocol
    
    init(timestamp: Date, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.timestamp = timestamp
        self.userDefaults = userDefaults
        super.init()
        self.name = "Track App Update"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let previousVersion = userDefaults.string(forKey: "io.rover.appVersion")
        let previousBuild = userDefaults.string(forKey: "io.rover.appBuild")
        
        let context = resolver.currentState.context
        let currentVersion = context.appVersion
        let currentBuild = context.appBuild
        
        if previousBuild == nil {
            let timestamp = Date()
            let operation = TrackEventOperation(eventName: "App Installed", attributes: nil, timestamp: timestamp)
            addOperation(operation)
        } else if currentVersion != previousVersion || currentBuild != previousBuild {
            var attributes = Attributes()
            
            if let previousVersion = previousVersion {
                attributes["previousVersion"] = previousVersion
            }
            
            if let previousBuild = previousBuild {
                attributes["previousBuild"] = previousBuild
            }
            
            let timestamp = Date()
            let operation = TrackEventOperation(eventName: "App Updated", attributes: attributes, timestamp: timestamp)
            addOperation(operation)
        }
        
        userDefaults.set(currentVersion, forKey: "io.rover.appVersion")
        userDefaults.set(currentBuild, forKey: "io.rover.appBuild")
        completionHandler()
    }
}
