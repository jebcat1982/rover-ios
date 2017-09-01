//
//  FrameworkContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct FrameworkContextProvider {
    let bundle: BundleProtocol
}

extension FrameworkContextProvider: ContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        if let sdkVersion = self.sdkVersion {
            logger.debug("Setting sdkVersion to: \(sdkVersion)")
            nextContext.sdkVersion = sdkVersion
        } else {
            logger.warn("Failed to capture SDK version")
            nextContext.sdkVersion = nil
        }
        
        return nextContext
    }
    
    var sdkVersion: String? {
        guard let dictionary = bundle.infoDictionary else {
            logger.warn("Invalid bundle")
            return nil
        }
        
        guard let version = dictionary["CFBundleShortVersionString"] as? String else {
            logger.warn("No version found in bundle")
            return nil
        }
        
        return version
    }
}
