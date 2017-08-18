//
//  FindExperienceOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class FindExperienceOperation: Operation {
    let experienceID: ID
    
    init(experienceID: ID) {
        self.experienceID = experienceID
        super.init()
        self.name = "Find Experience"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        if resolver.currentState.experiences[experienceID] != nil {
            completionHandler()
        }
        
        let operation = FetchExperienceOperation(experienceID: experienceID)
        addOperation(operation)
        completionHandler()
    }
}
