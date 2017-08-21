//
//  AddApplicationInfoToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddApplicationInfoToContextOperation: Operation {
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
            delegate?.warn("Failed to load infoDictionary from main bundle", operation: self)
        }
        
        if let localizedInfoDictionary = bundle.localizedInfoDictionary {
            for (key, value) in localizedInfoDictionary {
                info[key] = value
            }
        }
        
        reducer.reduce { state in
            var nextContext = state.context
            
            if let displayName = info["CFBundleDisplayName"] as? String {
                delegate?.debug("Setting appName to: \(displayName)", operation: self)
                nextContext.appName = displayName
            } else if let bundleName = info["CFBundleName"] as? String {
                delegate?.debug("Setting appName to: \(bundleName)", operation: self)
                nextContext.appName = bundleName
            } else {
                delegate?.warn("Failed to capture app name", operation: self)
                nextContext.appName = nil
            }
            
            if let shortVersion = info["CFBundleShortVersionString"] as? String {
                delegate?.debug("Setting appVersion to: \(shortVersion)", operation: self)
                nextContext.appVersion = shortVersion
            } else {
                delegate?.warn("Failed to capture appVersion", operation: self)
                nextContext.appVersion = nil
            }
            
            if let bundleVersion = info["CFBundleVersion"] as? String {
                delegate?.debug("Setting appBuild to: \(bundleVersion)", operation: self)
                nextContext.appBuild = bundleVersion
            } else {
                delegate?.warn("Failed to capture appBuild", operation: self)
                nextContext.appBuild = nil
            }
            
            if let bundleIdentifier = bundle.bundleIdentifier {
                delegate?.debug("Setting appNamespace to: \(bundleIdentifier)", operation: self)
                nextContext.appNamespace = bundleIdentifier
            } else {
                delegate?.warn("Failed to capture appNamespace", operation: self)
                nextContext.appNamespace = nil
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
