//
//  Profile.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct Profile: Codable {
    public var identifier: String?
    public var attributes = Attributes()
}

extension Profile: Equatable {
    
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.attributes == rhs.attributes
    }
}
