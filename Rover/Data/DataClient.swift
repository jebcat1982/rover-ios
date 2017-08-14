//
//  APIClient.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct DataClient {
    var baseURL = URL(string: "https://api.rover.io/")!
    var path = "graphql"
    var session: HTTPSession = URLSession(configuration: URLSessionConfiguration.default)
}

extension DataClient: GraphQLClient { }
