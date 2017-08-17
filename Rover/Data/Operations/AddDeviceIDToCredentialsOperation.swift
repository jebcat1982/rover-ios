//
//  AddDeviceIDToCredentialsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class AddDeviceIDToCredentialsOperation: ContainerOperation {
    let currentDevice: UIDeviceProtocol
    
    init(currentDevice: UIDeviceProtocol = UIDevice.current) {
        self.currentDevice = currentDevice
        super.init()
        self.name = "Add Device ID To Credentials"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        guard let identifierForVendor = currentDevice.identifierForVendor?.uuidString else {
            logger.error("Failed to obtain identifierForVendor")
            completionHandler()
            return
        }
        
        let deviceID = ID(rawValue: identifierForVendor)
        
        reducer.reduce { state in
            var nextCredentials = state.credentials
            nextCredentials.deviceID = deviceID
            
            var nextState = state
            nextState.credentials = nextCredentials
            return nextState
        }
        
        completionHandler()
    }
}
