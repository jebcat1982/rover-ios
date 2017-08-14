//
//  ID.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct ID: Codable, Equatable, RawRepresentable {
    
    var rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    init(extendedGraphemeClusterLiteral value: String) {
        self.rawValue = value
    }
    
    init(unicodeScalarLiteral value: String) {
        self.rawValue = value
    }
}

extension ID: ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        self.rawValue = value
    }
}

extension ID: Hashable {
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}
