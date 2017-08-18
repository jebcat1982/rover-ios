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
        guard let bundle = bundleType.init(identifier: "io.rover.Rover") else {
            delegate?.warn("Failed to capture SDK version: Bundle not found", operation: self)
            completionHandler()
            return
        }
        
        guard let dictionary = bundle.infoDictionary else {
            delegate?.warn("Failed to capture SDK version: Invalid bundle", operation: self)
            completionHandler()
            return
        }
        
        guard let version = dictionary["CFBundleShortVersionString"] as? String else {
            delegate?.warn("Failed to capture SDK version: No version found in bundle", operation: self)
            completionHandler()
            return
        }
        
        reducer.reduce { state in
            var nextContext = state.context
            nextContext.sdkVersion = version
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
