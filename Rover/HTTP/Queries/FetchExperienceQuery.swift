//
//  FetchExperienceQuery.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct FetchExperienceQuery: HTTPQuery {
    typealias Response = Experience
    
    var experienceID: ID
    
    var operationName: String? {
        return "FetchExperience"
    }
    
    var query: String {
        return """
            query FetchExperience($id: ID!) {
                experience(id: $id) {
                    name
                }
            }
            """
    }
    
    var variables: Encodable? {
        return ["id": experienceID]
    }
}
