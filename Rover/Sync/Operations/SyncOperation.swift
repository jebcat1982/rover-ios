//
//  SyncOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

class SyncOperation: QueryOperation<SyncQuery> {
    
    init() {
        let query = SyncQuery()
        super.init(query: query)
        self.name = "Sync"
    }
    
    override func handleResponse(_ response: SyncResponse, reducer: Reducer, resolver: Resolver) {
        reducer.reduce { state in
            var nextState = state
            nextState.profile = response.profile
            return nextState
        }
    }
}

// MARK: SyncQuery

struct SyncQuery: GraphQLQuery {
    typealias Response = SyncResponse
    
    var query: String {
        return """
            query {
                sync {
                    profile {
                        identifier
                        attributes
                    }
                    regions {
                        __typename
                        identifier
                        ... on BeaconRegion {
                            uuid
                            major
                            minor
                        }
                        ... on GeofenceRegion {
                            latitude
                            longitude
                            radius
                        }
                    }
                }
            }
            """
    }
}

// MARK: SyncResponse

struct SyncResponse: Decodable {
    var profile: Profile
    var regions: Set<CLRegion>
    
    enum CodingKeys: String, CodingKey {
        case profile
        case regions
    }
    
    enum RegionKeys: String, CodingKey {
        case typeName = "__typename"
        case identifier
        case uuid
        case major
        case minor
        case latitude
        case longitude
        case radius
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profile = try container.decode(Profile.self, forKey: .profile)
        regions = Set<CLRegion>()
        
        var regionsContainer = try container.nestedUnkeyedContainer(forKey: .regions)
        
        if let count = regionsContainer.count {
            regions.reserveCapacity(count)
        }
        
        while !regionsContainer.isAtEnd {
            let regionContainer = try regionsContainer.nestedContainer(keyedBy: RegionKeys.self)
            let typeName = try regionContainer.decode(String.self, forKey: .typeName)
            let identifier = try regionContainer.decode(String.self, forKey: .identifier)
            let region: CLRegion
            
            switch typeName {
            case "BeaconRegion":
                let uuid = try regionContainer.decode(UUID.self, forKey: .uuid)
                let major = try regionContainer.decode(CLBeaconMajorValue?.self, forKey: .major)
                let minor = try regionContainer.decode(CLBeaconMinorValue?.self, forKey: .minor)
                
                switch (major, minor) {
                case (let major?, let minor?):
                    region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
                case (let major?, _):
                    region = CLBeaconRegion(proximityUUID: uuid, major: major, identifier: identifier)
                default:
                    region = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
                }
            case "GeofenceRegion":
                let latitude = try regionContainer.decode(CLLocationDegrees.self, forKey: .latitude)
                let longitude = try regionContainer.decode(CLLocationDegrees.self, forKey: .longitude)
                let radius = try regionContainer.decode(CLLocationDistance.self, forKey: .radius)
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
            default:
                throw DecodingError.dataCorruptedError(forKey: RegionKeys.typeName, in: regionContainer, debugDescription: "__typename must be either BeaconRegion or GeofenceRegion – found \(typeName)")
            }
            
            regions.insert(region)
        }
    }
}
