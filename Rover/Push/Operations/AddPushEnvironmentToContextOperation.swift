//
//  AddPushEnvironmentToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddPushEnvironmentToContextOperation: ContainerOperation {
    let bundle: BundleProtocol
    
    init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
        super.init()
        self.name = "Add Push Environment To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            nextContext.pushEnvironment = pushEnvironment
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
    
    var pushEnvironment: String? {
        guard let path = bundle.path(forResource: "embedded", ofType: "mobileprovision") else {
            logger.warn("Could not detect push environment: Provisioning profile not found")
            return nil
        }
        
        guard let embeddedProfile = try? String(contentsOfFile: path, encoding: String.Encoding.ascii) else {
            logger.warn("Could not detect push environment: Failed to read provisioning profile at \(path)")
            return nil
        }
        
        let scanner = Scanner(string: embeddedProfile)
        var string: NSString?
        
        guard scanner.scanUpTo("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", into: nil), scanner.scanUpTo("</plist>", into: &string) else {
            logger.warn("Could not detect push environment: Unrecognized provisioning profile structure")
            return nil
        }
        
        guard let data = string?.appending("</plist>").data(using: String.Encoding.utf8) else {
            logger.warn("Could not detect push environment: Failed to decode provisioning profile")
            return nil
        }
        
        guard let plist = (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String: Any] else {
            logger.warn("Could not detect push environment: Failed to serialize provisioning profile")
            return nil
        }
        
        if let entitlements = plist["Entitlements"] as? [String: Any] {
            return entitlements["aps-environment"] as? String
        }
        
        return nil
    }
}
