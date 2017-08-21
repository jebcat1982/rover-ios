//
//  TrackExitRegionOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-21.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

class TrackExitRegionOperation: Operation {
    let region: CLRegion
    let timestamp: Date
    
    init(region: CLRegion, timestamp: Date = Date()) {
        self.region = region
        self.timestamp = timestamp
        super.init()
        self.name = "Track Exit Region"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        switch region {
        case let region as CLCircularRegion:
            let attributes: Attributes = [
                "identifier": region.identifier,
                "latitude": region.center.latitude,
                "longitude": region.center.longitude,
                "radius": region.radius
            ]
            
            let operation = TrackEventOperation(eventName: "Exit Geofence Region", attributes: attributes, timestamp: timestamp)
            addOperation(operation)
        case let region as CLBeaconRegion:
            var attributes: Attributes = [
                "identifier": region.identifier,
                "uuid": region.proximityUUID.uuidString
            ]
            
            if let major = region.major {
                attributes["major"] = major.intValue
            }
            
            if let minor = region.minor {
                attributes["minor"] = minor.intValue
            }
            
            let operation = TrackEventOperation(eventName: "Exit Beacon Region", attributes: attributes, timestamp: timestamp)
            addOperation(operation)
        default:
            break
        }
        
        completionHandler()
    }
}
