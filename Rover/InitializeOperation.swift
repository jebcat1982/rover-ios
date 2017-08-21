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
        super.init(operations: [
            AddAccountTokenToCredentialsOperation(accountToken: accountToken),
            AddDeviceIdentifierToCredentialsOperation(),
            RestoreProfileIdentifierFromUserDefaultsOperation(),
            CaptureContextOperation()
            ])
        self.name = "Initialize"
    }
}
