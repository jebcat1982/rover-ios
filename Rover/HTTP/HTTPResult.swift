//
//  HTTPResult.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public enum HTTPResult<T> where T : Decodable {
    case error(error: Error?, shouldRetry: Bool)
    case success(response: T)
}
