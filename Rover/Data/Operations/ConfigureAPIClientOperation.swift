//
//  ConfigureAPIClientOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class ConfigureAPIClientOperation: ContainerOperation {
    let baseURL: URL?
    let path: String?
    let session: HTTPSession?
    
    init(baseURL: URL?, path: String?, session: HTTPSession?) {
        self.baseURL = baseURL
        self.path = path
        self.session = session
        
        super.init()
        self.name = "Configure API Client"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextClient = state.dataClient
            
            if let baseURL = self.baseURL {
                nextClient.baseURL = baseURL
            }
            
            if let path = self.path {
                nextClient.path = path
            }
            
            if let session = self.session {
                nextClient.session = session
            }
            
            var nextState = state
            nextState.dataClient = nextClient
            return nextState
        }
        completionHandler()
    }
}
