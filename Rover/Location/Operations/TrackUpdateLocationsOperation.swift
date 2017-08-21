//
//  TrackUpdateLocationsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-21.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

class TrackUpdateLocationsOperation: Operation {
    let locations: [CLLocation]
    
    init(locations: [CLLocation]) {
        self.locations = locations
        super.init()
        self.name = "Track Update Locations"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let operations: [Operation] = locations.map { location in
            var attributes: Attributes = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude,
                "altitude": location.altitude,
                "horizontalAccuracy": location.horizontalAccuracy,
                "verticalAccuracy": location.verticalAccuracy
            ]
            
            if let floor = location.floor?.level {
                attributes["floor"] = floor
            }
            
            return TrackEventOperation(eventName: "Update Location", attributes: attributes, timestamp: location.timestamp)
        }
        
        addOperations(operations)
        completionHandler()
    }
}
