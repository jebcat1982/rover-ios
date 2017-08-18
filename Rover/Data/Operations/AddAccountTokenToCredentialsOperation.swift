//
//  AddAccountTokenToCredentialsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class AddAccountTokenToCredentialsOperation: Operation {
    let accountToken: String
    
    init(accountToken: String) {
        self.accountToken = accountToken
        super.init()
        self.name = "Add Account Token To Credentials"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        delegate?.debug("Using token: \(accountToken)", operation: self)
        
        reducer.reduce { state in
            var nextCredentials = state.credentials
            nextCredentials.accountToken = accountToken
            
            var nextState = state
            nextState.credentials = nextCredentials
            return nextState
        }
        completionHandler()
    }
}
