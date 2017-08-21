//
//  TrackEventOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class TrackEventOperation: Operation {
    let eventName: String
    let attributes: Attributes?
    let timestamp: Date
    
    init(eventName: String, attributes: Attributes?, timestamp: Date = Date()) {
        self.eventName = eventName
        self.attributes = attributes
        self.timestamp = timestamp
        
        super.init(operations: [
            UpdateContextOperation(),
            AddEventOperation(eventName: eventName, attributes: attributes, timestamp: timestamp),
            PersistEventsOperation(),
            FlushEventsOperation()
            ])
        
        self.name = "Track Event"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        delegate?.debug("Tracking \"\(eventName)\" event at \(timestamp)", operation: self)
        
        // TODO: Log event attributes in TrackEventOperation - https://github.com/RoverPlatform/rover-ios/issues/196
        delegate?.debug("TODO: Log event attributes in TrackEventOperation - https://github.com/RoverPlatform/rover-ios/issues/196", operation: self)
        
        super.execute(reducer: reducer, resolver: resolver, completionHandler: completionHandler)
    }
}
