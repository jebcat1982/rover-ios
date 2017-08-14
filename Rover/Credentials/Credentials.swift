//
//  Credentials.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

public struct Credentials {
    public var accountToken: String?
    public var deviceID: ID?
    public var profileID: ID?
    
    public init() { }
}

extension Credentials: Equatable {
    
    public static func == (lhs: Credentials, rhs: Credentials) -> Bool {
        return lhs.accountToken == rhs.accountToken && lhs.deviceID == rhs.deviceID && lhs.profileID == rhs.profileID
    }
}
