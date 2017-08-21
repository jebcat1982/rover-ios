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
        let context = resolver.currentState.context
        let currentVersion = context.appVersion
        let currentBuild = context.appBuild
        
        let currentVersionString = versionString(version: currentVersion, build: currentBuild)
        delegate?.debug("Current version: \(currentVersionString)", operation: self)
        
        let previousVersion = userDefaults.string(forKey: "io.rover.appVersion")
        let previousBuild = userDefaults.string(forKey: "io.rover.appBuild")
        
        let previousVersionString = versionString(version: previousVersion, build: previousBuild)
        delegate?.debug("Previous version: \(previousVersionString)", operation: self)
        
        if previousVersion == nil || previousBuild == nil {
            delegate?.debug("Previous version not found – first time running app with Rover", operation: self)
            
            let timestamp = Date()
            let operation = TrackEventOperation(eventName: "App Installed", attributes: nil, timestamp: timestamp)
            addOperation(operation)
        } else if currentVersion != previousVersion || currentBuild != previousBuild {
            delegate?.debug("Current and previous versions do not match – app has been updated", operation: self)
            
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
        } else {
            delegate?.debug("Current and previous versions match – nothing to track", operation: self)
        }
        
        userDefaults.set(currentVersion, forKey: "io.rover.appVersion")
        userDefaults.set(currentBuild, forKey: "io.rover.appBuild")
        completionHandler()
    }
    
    func versionString(version: String?, build: String?) -> String {
        if let version = version {
            if let build = build {
                return "\(version) (\(build))"
            }
            
            return "\(version)"
        }
        
        return "n/a"
    }
}
