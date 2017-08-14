//
//  UpdateContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class UpdateContextOperation: ContainerOperation {
    
    init() {
        super.init(operations: [
            AddLocaleToContextOperation(),
            AddTelephonyInfoToContextOperation(),
            AddTimeZoneToContextOperation(),
            AddReachabilityInfoToContextOperation()
            ])
        self.name = "Update Context"
    }
}
