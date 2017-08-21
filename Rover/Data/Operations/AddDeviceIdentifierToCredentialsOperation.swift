//
//  AddDeviceIdentifierToCredentialsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class AddDeviceIdentifierToCredentialsOperation: Operation {
    let currentDevice: UIDeviceProtocol
    
    init(currentDevice: UIDeviceProtocol = UIDevice.current) {
        self.currentDevice = currentDevice
        super.init()
        self.name = "Add Device ID To Credentials"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        guard let identifierForVendor = currentDevice.identifierForVendor?.uuidString else {
            delegate?.error("Failed to obtain identifierForVendor", operation: self)
            completionHandler()
            return
        }
        
        delegate?.debug("Setting deviceIdentifier to: \(identifierForVendor)", operation: self)
        
        reducer.reduce { state in
            var nextCredentials = state.credentials
            nextCredentials.deviceIdentifier = identifierForVendor
            
            var nextState = state
            nextState.credentials = nextCredentials
            return nextState
        }
        
        completionHandler()
    }
}
