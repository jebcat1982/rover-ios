//
//  TrackAppUpdateOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class TrackAppUpdateOperation: Operation {
//    let timestamp: Date
//    let userDefaults: UserDefaultsProtocol
//    
//    init(timestamp: Date = Date(), userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
//        self.timestamp = timestamp
//        self.userDefaults = userDefaults
//        super.init()
//        self.name = "Track App Update"
//    }
//    
//    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
//        let context = resolver.currentState.context
//        let currentVersion = context.appVersion
//        let currentBuild = context.appBuild
//        
//        let currentVersionString = versionString(version: currentVersion, build: currentBuild)
//        logger.debug("Current version: \(currentVersionString)")
//        
//        let previousVersion = userDefaults.string(forKey: "io.rover.appVersion")
//        let previousBuild = userDefaults.string(forKey: "io.rover.appBuild")
//        
//        let previousVersionString = versionString(version: previousVersion, build: previousBuild)
//        logger.debug("Previous version: \(previousVersionString)")
//        
//        if previousVersion == nil || previousBuild == nil {
//            logger.debug("Previous version not found – first time running app with Rover")
//            
//            let operation = TrackEventOperation(eventName: "Install App", attributes: nil, timestamp: timestamp)
//            addOperation(operation)
//        } else if currentVersion != previousVersion || currentBuild != previousBuild {
//            logger.debug("Current and previous versions do not match – app has been updated")
//            
//            var attributes = Attributes()
//            
//            if let previousVersion = previousVersion {
//                attributes["previousVersion"] = previousVersion
//            }
//            
//            if let previousBuild = previousBuild {
//                attributes["previousBuild"] = previousBuild
//            }
//            
//            let operation = TrackEventOperation(eventName: "Update App", attributes: attributes, timestamp: timestamp)
//            addOperation(operation)
//        } else {
//            logger.debug("Current and previous versions match – nothing to track")
//        }
//        
//        userDefaults.set(currentVersion, forKey: "io.rover.appVersion")
//        userDefaults.set(currentBuild, forKey: "io.rover.appBuild")
//        completionHandler()
//    }
//    
//    func versionString(version: String?, build: String?) -> String {
//        if let version = version {
//            if let build = build {
//                return "\(version) (\(build))"
//            }
//            
//            return "\(version)"
//        }
//        
//        return "n/a"
//    }
}
