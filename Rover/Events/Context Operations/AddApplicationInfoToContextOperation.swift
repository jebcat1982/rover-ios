//
//  AddApplicationInfoToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddApplicationInfoToContextOperation: ContainerOperation {
    let bundle: BundleProtocol
    
    init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
        super.init()
        self.name = "Add Application Info To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        var info = [String: Any]()
        
        if let infoDictionary = bundle.infoDictionary {
            for (key, value) in infoDictionary {
                info[key] = value
            }
        } else {
            logger.warn("Failed to load infoDictionary from main bundle")
        }
        
        if let localizedInfoDictionary = bundle.localizedInfoDictionary {
            for (key, value) in localizedInfoDictionary {
                info[key] = value
            }
        }
        
        reducer.reduce { state in
            var nextContext = state.context
            
            if let displayName = info["CFBundleDisplayName"] as? String {
                nextContext.appName = displayName
            } else if let bundleName = info["CFBundleName"] as? String {
                nextContext.appName = bundleName
            } else {
                logger.warn("Failed to capture app name")
            }
            
            if let shortVersion = info["CFBundleShortVersionString"] as? String {
                nextContext.appVersion = shortVersion
            } else {
                logger.warn("Failed to capture app version")
            }
            
            if let bundleVersion = info["CFBundleVersion"] as? String {
                nextContext.appBuild = bundleVersion
            } else {
                logger.warn("Failed to capture app build")
            }
            
            if let bundleIdentifier = bundle.bundleIdentifier {
                nextContext.appNamespace = bundleIdentifier
            } else {
                logger.warn("Failed to capture app namespace")
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
