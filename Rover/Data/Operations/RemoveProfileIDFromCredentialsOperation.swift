//
//  RemoveProfileIDFromCredentialsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class RemoveProfileIDFromCredentialsOperation: Operation {
    
    init() {
        super.init()
        self.name = "Remove Profile Identifier From Credentials"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextCredentials = state.credentials
            nextCredentials.profileIdentifier = nil
            
            var nextState = state
            nextState.credentials = nextCredentials
            return nextState
        }
        completionHandler()
    }
}
