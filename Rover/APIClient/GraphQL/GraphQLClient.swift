//
//  GraphQLClient.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

protocol GraphQLClient: HTTPClient { }

extension GraphQLClient {
    
    func uploadTask<T>(with query: T, authHeaders: [String: String], completionHandler: ((HTTPResult<T.Response>) -> Void)?) -> HTTPTask where T: GraphQLQuery {
        return uploadTask(with: query, authHeaders: authHeaders, completionHandler: { (result: HTTPResult<GraphQLRoot<T.Response>>) in
            let flattenedResult: HTTPResult<T.Response>
            switch result {
            case let .error(error, shouldRetry):
                flattenedResult = .error(error: error, shouldRetry: shouldRetry)
            case let .success(root):
                flattenedResult = .success(response: root.data)
            }
            completionHandler?(flattenedResult)
        })
    }
}

// MARK: GraphQLRoot

struct GraphQLRoot<T>: Decodable where T: Decodable {
    let data: T
}
