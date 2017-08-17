//
//  FetchExperienceOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class FetchExperienceOperation: QueryOperation<FetchExperienceQuery> {
    
    init(experienceID: ID) {
        let query = FetchExperienceQuery(experienceID: experienceID)
        super.init(query: query)
        self.name = "Fetch Experience \(experienceID)"
    }
    
    override func handleResponse(_ response: Experience, reducer: Reducer, resolver: Resolver) {
        reducer.reduce { state in
            var nextExperiences = state.experiences
            nextExperiences[query.experienceID] = response
            
            var nextState = state
            nextState.experiences = nextExperiences
            return nextState
        }
    }
}

// MARK: FetchExperienceQuery

struct FetchExperienceQuery: GraphQLQuery {
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
