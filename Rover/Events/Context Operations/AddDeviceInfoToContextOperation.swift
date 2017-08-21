//
//  AddDeviceInfoToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class AddDeviceInfoToContextOperation: Operation {
    let device: UIDeviceProtocol
    
    init(device: UIDeviceProtocol = UIDevice.current) {
        self.device = device
        super.init()
        self.name = "Add Device Info To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            delegate?.debug("Setting operatingSystemName to: \(device.systemName)", operation: self)
            nextContext.operatingSystemName = device.systemName
            
            delegate?.debug("Setting operatingSystemVersion to: \(device.systemVersion)", operation: self)
            nextContext.operatingSystemVersion = device.systemVersion
            
            delegate?.debug("Setting deviceManufacturer to: Apple", operation: self)
            nextContext.deviceManufacturer = "Apple"
            
            if let deviceModel = self.deviceModel() {
                delegate?.debug("Setting deviceModel to: \(deviceModel)", operation: self)
                nextContext.deviceModel = deviceModel
            } else {
                delegate?.warn("Failed to capture device model", operation: self)
                nextContext.deviceModel = nil
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
    
    func deviceModel() -> String? {
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
}
