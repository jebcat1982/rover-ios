//
//  DeviceContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct DeviceContextProvider {
    let device: UIDeviceProtocol
}

extension DeviceContextProvider: ContextProvider {
    
    var deviceModel: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let size = MemoryLayout<CChar>.size
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: size) {
                String(cString: UnsafePointer<CChar>($0))
            }
        }
        if let model = String(validatingUTF8: modelCode) {
            return model
        }
        return nil
    }
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        logger.debug("Setting operatingSystemName to: \(device.systemName)")
        nextContext.operatingSystemName = device.systemName
        
        logger.debug("Setting operatingSystemVersion to: \(device.systemVersion)")
        nextContext.operatingSystemVersion = device.systemVersion
        
        logger.debug("Setting deviceManufacturer to: Apple")
        nextContext.deviceManufacturer = "Apple"
        
        if let deviceModel = self.deviceModel {
            logger.debug("Setting deviceModel to: \(deviceModel)")
            nextContext.deviceModel = deviceModel
        } else {
            logger.warn("Failed to capture device model")
            nextContext.deviceModel = nil
        }
        
        return nextContext
    }
}
