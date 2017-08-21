//
//  AddSDKVersionToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddSDKVersionToContextOperation: Operation {
    let bundleType: BundleProtocol.Type
    
    init(bundleType: BundleProtocol.Type = Bundle.self) {
        self.bundleType = bundleType
        super.init()
        self.name = "Add SDK Version To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            if let sdkVersion = self.sdkVersion {
                delegate?.debug("Setting sdkVersion to: \(sdkVersion)", operation: self)
                nextContext.sdkVersion = sdkVersion
            } else {
                delegate?.warn("Failed to capture SDK version", operation: self)
                nextContext.sdkVersion = nil
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
    
    var sdkVersion: String? {
        guard let bundle = bundleType.init(identifier: "io.rover.Rover") else {
            delegate?.warn("Bundle not found", operation: self)
            return nil
        }
        
        guard let dictionary = bundle.infoDictionary else {
            delegate?.warn("Invalid bundle", operation: self)
            return nil
        }
        
        guard let version = dictionary["CFBundleShortVersionString"] as? String else {
            delegate?.warn("No version found in bundle", operation: self)
            return nil
        }
        
        return version
    }
}
