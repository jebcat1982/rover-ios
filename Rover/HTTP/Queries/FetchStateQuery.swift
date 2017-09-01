//
//  SyncQuery.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct FetchStateQuery: HTTPQuery {
    typealias Response = State
    
    var query: String {
        return """
            query {
                state {
                    profile {
                        identifier
                        attributes
                    }
                    regions {
                        __typename
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
