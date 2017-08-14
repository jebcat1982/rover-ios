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
            var nextAPIClient = state.apiClient
            
            if let baseURL = self.baseURL {
                nextAPIClient.baseURL = baseURL
            }
            
            if let path = self.path {
                nextAPIClient.path = path
            }
            
            if let session = self.session {
                nextAPIClient.session = session
            }
            
            var nextState = state
            nextState.apiClient = nextAPIClient
            return nextState
        }
        completionHandler()
    }
}
