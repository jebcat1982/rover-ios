//
//  ID.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct ID: Codable, Equatable, RawRepresentable {
    
    public var rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.rawValue = value
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.rawValue = value
    }
}

extension ID: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension ID: Hashable {
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
}
