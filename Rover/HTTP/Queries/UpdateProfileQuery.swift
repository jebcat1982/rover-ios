//
//  UpdateProfileQuery.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct UpdateProfileQuery: HTTPQuery {
    typealias Response = String
    
    var attributes: Attributes
    
    var operationName: String? {
        return "UpdateProfile"
    }
    
    var query: String {
        return """
            mutation UpdateProfile($updates: Attributes!) {
                updateProfile(updates: $updates)
            }
            """
    }
    
    var variables: Encodable? {
        return ["updates": attributes]
    }
    
//    enum CodingKeys: String, CodingKey {
//        case operationName
//        case query
//        case variables
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(operationName, forKey: .operationName)
//        try container.encode(query, forKey: .query)
//        try container.encode(variables, forKey: .variables)
//    }
}
