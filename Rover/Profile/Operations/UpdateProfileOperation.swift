//
//  UpdateProfileOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class UpdateProfileOperation: QueryOperation<UpdateProfileQuery> {
    
    init(attributes: Attributes) {
        let query = UpdateProfileQuery(attributes: attributes)
        super.init(query: query)
        self.name = "Update Profile"
    }
}

// MARK: UpdateProfileQuery

struct UpdateProfileQuery: GraphQLQuery {
    typealias Response = UpdateProfileResponse
    
    var attributes: Attributes
    
    var operationName: String? {
        return "UpdateProfile"
    }
    
    var query: String {
        return """
            mutation UpdateProfile($updates: [ProfileUpdate]!) {
                updateProfile(updates: $updates)
            }
            """
    }
    
    var variables: Encodable? {
        return ["updates": attributes]
    }
    
    enum CodingKeys: String, CodingKey {
        case operationName
        case query
        case variables
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operationName, forKey: .operationName)
        try container.encode(query, forKey: .query)
        try container.encode(variables, forKey: .variables)
    }
}

// MARK: UpdateProfileResponse

struct UpdateProfileResponse: Decodable { }
