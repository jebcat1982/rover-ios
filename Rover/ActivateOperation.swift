//
//  ActivateOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class ActivateOperation: Operation {
    
    init(timestamp: Date) {
        super.init(operations: [
            TrackEventOperation(eventName: "Open App", attributes: nil, timestamp: timestamp),
            SyncOperation()
            ])
        self.name = "Activate"
    }
}
