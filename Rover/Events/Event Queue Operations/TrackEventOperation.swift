//
//  TrackEventOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class TrackEventOperation: ContainerOperation {
    
    init(eventName: String, attributes: Attributes?, timestamp: Date) {
        super.init(operations: [
            UpdateContextOperation(),
            AddEventOperation(eventName: eventName, attributes: attributes, timestamp: timestamp),
            PersistEventsOperation(),
            FlushEventsOperation()
            ])
        
        self.name = "Track Event"
    }
}
