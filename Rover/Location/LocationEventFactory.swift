//
//  LocationEventFactory.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

struct LocationEventFactory {
    
    static func enterRegionEvent(region: CLRegion) -> Event {
        switch region {
        case let region as CLCircularRegion:
            let attributes: Attributes = [
                "identifier": region.identifier,
                "latitude": region.center.latitude,
                "longitude": region.center.longitude,
                "radius": region.radius
            ]
            return Event(name: "Enter Geofence Region", attributes: attributes)
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
            
            return Event(name: "Enter Beacon Region", attributes: attributes)
        default:
            fatalError("CLRegion must of type CLCircularRegion or CLBeaconRegion")
        }
    }
    
    static func exitRegionEvent(region: CLRegion) -> Event {
        switch region {
        case let region as CLCircularRegion:
            let attributes: Attributes = [
                "identifier": region.identifier,
                "latitude": region.center.latitude,
                "longitude": region.center.longitude,
                "radius": region.radius
            ]
            
            return Event(name: "Exit Geofence Region", attributes: attributes)
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
            
            return Event(name: "Exit Beacon Region", attributes: attributes)
        default:
            fatalError("CLRegion must of type CLCircularRegion or CLBeaconRegion")
        }
    }
    
    static func locationUpdateEvent(location: CLLocation) -> Event {
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
        
        return Event(name: "Update Location", attributes: attributes, timestamp: location.timestamp)
    }
    
    static func visitEvent(visit: CLVisit) -> Event {
        let attributes: Attributes = [
            "latitude": visit.coordinate.latitude,
            "longiutde": visit.coordinate.longitude,
            "accuracy": visit.horizontalAccuracy,
            "arrival": visit.arrivalDate,
            "departure": visit.departureDate
        ]
        
        return Event(name: "Visit", attributes: attributes)
    }
}

