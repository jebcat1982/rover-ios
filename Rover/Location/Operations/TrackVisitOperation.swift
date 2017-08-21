//
//  TrackVisitOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-21.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

class TrackVisitOperation: Operation {
    let visit: CLVisit
    let timestamp: Date
    
    init(visit: CLVisit, timestamp: Date = Date()) {
        self.visit = visit
        self.timestamp = timestamp
        super.init()
        self.name = "Track Visit"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let attributes: Attributes = [
            "latitude": visit.coordinate.latitude,
            "longiutde": visit.coordinate.longitude,
            "accuracy": visit.horizontalAccuracy,
            "arrival": visit.arrivalDate,
            "departure": visit.departureDate
        ]
        
        let operation = TrackEventOperation(eventName: "Visit", attributes: attributes, timestamp: timestamp)
        addOperation(operation)
        completionHandler()
    }
}
