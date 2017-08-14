//
//  Event.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct Event: Encodable {
    let uuid = UUID()
    var name: String
    var attributes: Attributes?
    var timestamp: Date
    var context: Context
    var credentials: Credentials
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case attributes
        case timestamp
    }
}
