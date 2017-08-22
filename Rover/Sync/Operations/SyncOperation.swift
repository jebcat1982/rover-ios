//
//  SyncOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

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
    var regions: [AnyRegion]
    
    enum CodingKeys: String, CodingKey {
        case profile
        case regions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profile = try container.decode(Profile.self, forKey: .profile)
        regions = try container.decode([AnyRegion].self, forKey: .regions)
    }
}
