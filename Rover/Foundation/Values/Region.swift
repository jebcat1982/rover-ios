//
//  Region.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public enum Region {
    case beacon(uuid: UUID, major: Double?, minor: Double?)
    case geofence(latitude: Double, longitude: Double, radius: Int)
}

extension Region {
    
    public var identifier: String {
        switch self {
        case let .beacon(uuid, major, minor):
            switch (major, minor) {
            case let (major?, minor?):
                return "\(uuid):\(major):\(minor)"
            case let (major?, _):
                return "\(uuid):\(major)"
            default:
                return uuid.uuidString
            }
        case let .geofence(latitude, longitude, radius):
            return "\(latitude):\(longitude):\(radius)"
        }
    }
}

extension Region: Codable {
    
    enum CodingKeys: String, CodingKey {
        case typeName = "__typename"
        case uuid
        case major
        case minor
        case latitude
        case longitude
        case radius
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .typeName)
        switch typeName {
        case "BeaconRegion":
            let uuid = try container.decode(UUID.self, forKey: .uuid)
            let major = try container.decode(Double.self, forKey: .major)
            let minor = try container.decode(Double.self, forKey: .minor)
            self = .beacon(uuid: uuid, major: major, minor: minor)
        case "GeofenceRegion":
            let latitude = try container.decode(Double.self, forKey: .latitude)
            let longitude = try container.decode(Double.self, forKey: .longitude)
            let radius = try container.decode(Int.self, forKey: .radius)
            self = .geofence(latitude: latitude, longitude: longitude, radius: radius)
        default:
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.typeName, in: container, debugDescription: "Expected beacon or geofence – found \(typeName)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .beacon(uuid, major, minor):
            try container.encode("BeaconRegion", forKey: .typeName)
            try container.encode(uuid, forKey: .uuid)
            try container.encode(major, forKey: .major)
            try container.encode(minor, forKey: .minor)
        case let .geofence(latitude, longitude, radius):
            try container.encode("GeofenceRegion", forKey: .typeName)
            try container.encode(latitude, forKey: .latitude)
            try container.encode(longitude, forKey: .longitude)
            try container.encode(radius, forKey: .radius)
        }
    }
}

extension Region: Equatable {
    
    public static func ==(lhs: Region, rhs: Region) -> Bool {
        switch (lhs, rhs) {
        case let (.beacon(lhsUUID, lhsMajor, lhsMinor), .beacon(rhsUUID, rhsMajor, rhsMinor)):
            return lhsUUID == rhsUUID && lhsMajor == rhsMajor && lhsMinor == rhsMinor
        case let (.geofence(lhsLatitude, lhsLongitude, lhsRadius), .geofence(rhsLatitude, rhsLongitude, rhsRadius)):
            return lhsLatitude == rhsLatitude && lhsLongitude == rhsLongitude && lhsRadius == rhsRadius
        default:
            return false
        }
    }
}

extension Region: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}
