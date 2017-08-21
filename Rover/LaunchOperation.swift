//
//  LaunchOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-21.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class LaunchOperation: Operation {
    
    init(timestamp: Date = Date()) {
        super.init(operations: [
            TrackAppUpdateOperation(timestamp: timestamp)
            ])
        self.name = "Launch"
    }
}
