//
//  Credentials.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct Credentials {
    var accountToken: String?
    var deviceIdentifier: String?
    var profileIdentifier: String?
}

extension Credentials: Equatable {
    
    static func == (lhs: Credentials, rhs: Credentials) -> Bool {
        return lhs.accountToken == rhs.accountToken && lhs.deviceIdentifier == rhs.deviceIdentifier && lhs.profileIdentifier == rhs.profileIdentifier
    }
}
