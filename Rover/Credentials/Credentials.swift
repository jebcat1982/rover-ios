//
//  Credentials.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct Credentials {
    var accountToken: String?
    var deviceID: ID?
    var profileID: ID?
}

extension Credentials: Equatable {
    
    static func == (lhs: Credentials, rhs: Credentials) -> Bool {
        return lhs.accountToken == rhs.accountToken && lhs.deviceID == rhs.deviceID && lhs.profileID == rhs.profileID
    }
}
