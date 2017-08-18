//
//  QueryOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class QueryOperation<T>: Operation where T: GraphQLQuery {
    let query: T
    
    var credentials: Credentials?
    var uploadTask: HTTPTask?
    var result: HTTPResult<T.Response>?
    
    init(query: T) {
        self.query = query
        super.init()
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let credentials = self.credentials ?? resolver.currentState.credentials
        let authHeaders = self.authHeaders(from: credentials)
        
        uploadTask = resolver.currentState.dataClient.uploadTask(with: query, authHeaders: authHeaders) { result in
            self.result = result
            
            switch result {
            case let .error(error, shouldRetry):
                if let error = error {
                    logger.error("Query failed: \(error.localizedDescription)")
                }
                
                self.handleError(error: error, shouldRetry: shouldRetry, reducer: reducer, resolver: resolver)
            case let .success(response):
                self.handleResponse(response, reducer: reducer, resolver: resolver)
            }
            
            completionHandler()
        }
        uploadTask?.resume()
    }
    
    override func cancel() {
        uploadTask?.cancel()
        super.cancel()
    }
    
    func authHeaders(from credentials: Credentials) -> [String: String] {
        var authHeaders = [String: String]()
        
        if let accountToken = credentials.accountToken {
            authHeaders["x-rover-account-token"] = accountToken
        }
        
        if let deviceID = credentials.deviceID {
            authHeaders["x-rover-device-id"] = deviceID.rawValue
        }
        
        if let profileID = credentials.profileID {
            authHeaders["x-rover-profile-id"] = profileID.rawValue
        }
        
        return authHeaders
    }
    
    func handleResponse(_ response: T.Response, reducer: Reducer, resolver: Resolver) { }
    
    func handleError(error: Error?, shouldRetry: Bool, reducer: Reducer, resolver: Resolver) { }
}

