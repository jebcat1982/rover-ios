//
//  InitializeOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class InitializeOperation: Operation {
    
    init(accountToken: String) {
        let timestamp = Date()
        super.init(operations: [
            AddAccountTokenToCredentialsOperation(accountToken: accountToken),
            AddDeviceIDToCredentialsOperation(),
            RestoreProfileIDFromUserDefaultsOperation(),
            CaptureContextOperation(),
            TrackAppUpdateOperation(timestamp: timestamp)
            ])
        self.name = "Initialize"
    }
}
