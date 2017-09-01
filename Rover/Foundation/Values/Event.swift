//
//  Event.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct Event: Codable {
    public var attributes: Attributes?
    public var name: String
    public var timestamp: Date
    public var uuid: UUID
    
    public init(name: String, attributes: Attributes? = nil, timestamp: Date = Date(), uuid: UUID = UUID()) {
        self.uuid = uuid
        self.name = name
        self.attributes = attributes
        self.timestamp = timestamp
    }
}

extension Event: Equatable {
    
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.name == rhs.name && lhs.attributes == rhs.attributes && lhs.timestamp == rhs.timestamp
    }
}
