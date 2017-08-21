//
//  AddProfileIdentifierToCredentialsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class AddProfileIdentifierToCredentialsOperation: Operation {
    let identifier: String
    
    init(identifier: String) {
        self.identifier = identifier
        super.init()
        self.name = "Add Profile Identifier To Credentials"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        delegate?.debug("Using identifier: \(identifier)", operation: self)
        
        reducer.reduce { state in
            var nextCredentials = state.credentials
            nextCredentials.profileIdentifier = identifier
            
            var nextState = state
            nextState.credentials = nextCredentials
            return nextState
        }
        completionHandler()
    }
}
