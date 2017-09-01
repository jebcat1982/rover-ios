//
//  Credentials.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

public struct Credentials: Codable {
    public var accountToken: String
    public var profileIdentifier: String?
    
    public init(accountToken: String, profileIdentifier: String? = nil) {
        self.accountToken = accountToken
        self.profileIdentifier = profileIdentifier
    }
}

extension Credentials: Equatable {
    
    public static func == (lhs: Credentials, rhs: Credentials) -> Bool {
        return lhs.accountToken == rhs.accountToken && lhs.profileIdentifier == rhs.profileIdentifier
    }
}
