//
//  GraphQLQuery.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

protocol GraphQLQuery: Encodable {
    associatedtype Response: Decodable
    
    var operationName: String? { get }
    var query: String { get }
    var variables: Encodable? { get }
}

extension GraphQLQuery {
    
    var operationName: String? {
        return nil
    }
    
    var variables: Encodable? {
        return nil
    }
}
