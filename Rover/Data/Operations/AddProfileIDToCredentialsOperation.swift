//
//  AddProfileIDToCredentialsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class AddProfileIDToCredentialsOperation: ContainerOperation {
    let profileID: ID
    
    init(profileID: ID) {
        self.profileID = profileID
        super.init()
        self.name = "Add Profile ID To Credentials"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextCredentials = state.credentials
            nextCredentials.profileID = profileID
            
            var nextState = state
            nextState.credentials = nextCredentials
            return nextState
        }
        completionHandler()
    }
}
