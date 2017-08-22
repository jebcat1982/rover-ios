//
//  Region.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-22.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

struct AnyRegion {
    let value: Any
    let identifier: String
    let clRegion: CLRegion
    let isEqual: (AnyRegion) -> Bool
    
    init<T: Region>(_ value: T) {
        self.value = value
        self.identifier = value.identifier
        self.clRegion = value.clRegion
        self.isEqual = { rhs in
            let a = value
            guard let b = rhs.value as? T else {
                return false
            }
            return a == b
        }
    }
}

extension AnyRegion: Equatable {
    
    static func == (lhs: AnyRegion, rhs: AnyRegion) -> Bool {
        return lhs.isEqual(rhs)
    }
}

extension AnyRegion: Hashable {
    
    var hashValue: Int {
        return identifier.hashValue
    }
}

protocol Region: Codable, Equatable {
    var identifier: String { get }
    var clRegion: CLRegion { get }
}

struct BeaconRegion: Codable {
    var uuid: UUID
    var major: Int?
    var minor: Int?
}

extension BeaconRegion: Region {
    
    static func == (lhs: BeaconRegion, rhs: BeaconRegion) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.major == rhs.major && lhs.minor == rhs.minor
    }
    
    var identifier: String {
        switch (major, minor) {
        case (let major?, let minor?):
            return "\(uuid):\(major):\(minor)"
        case (let major?, _):
            return "\(uuid):\(major)"
        default:
            return "\(uuid)"
        }
    }
    
    var clRegion: CLRegion {
        switch (major, minor) {
        case (let major?, let minor?):
            return CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: identifier)
        case (let major?, _):
            return CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), identifier: identifier)
        default:
            return CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
        }
    }
}

struct GeofenceRegion: Codable {
    var latitude: Double
    var longitude: Double
    var radius: Int
}

extension GeofenceRegion: Region {
    
    static func == (lhs: GeofenceRegion, rhs: GeofenceRegion) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.radius == rhs.radius
    }
    
    var identifier: String {
        return "\(latitude):\(longitude):\(radius)"
    }
    
    var clRegion: CLRegion {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return CLCircularRegion(center: center, radius: CLLocationDistance(radius), identifier: identifier)
    }
}
