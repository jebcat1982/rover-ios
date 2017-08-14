//
//  HTTPError.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case emptyResponseData
    case failedToDecodeResponseData
    case failedToUnzipResponseData
    case invalidResponse
    case invalidResponseData(message: String)
    case invalidStatusCode(statusCode: Int)
    case invalidURL
}

extension HTTPError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .emptyResponseData:
            return "Empty response data"
        case .failedToDecodeResponseData:
            return "Failed to deserialized response data"
        case .failedToUnzipResponseData:
            return "Failed to unzipe response data"
        case .invalidResponse:
            return "Invalid response"
        case let .invalidResponseData(message):
            return "Invalid response data: \(message)"
        case let .invalidStatusCode(statusCode):
            return "Invalid status code: \(statusCode)"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
