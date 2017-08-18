//
//  ActivateOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class ActivateOperation: Operation {
    
    init() {
        let timestamp = Date()
        super.init(operations: [
            TrackEventOperation(eventName: "App Opened", attributes: nil, timestamp: timestamp),
            SyncOperation()
            ])
        self.name = "Activate"
    }
}
