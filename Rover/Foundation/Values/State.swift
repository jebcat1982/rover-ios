//
//  State.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct State: Codable {
    public var profile: Profile
    public var regions: Set<Region>
    
    public init(profile: Profile, regions: Set<Region>) {
        self.profile = profile
        self.regions = regions
    }
}

extension State: Equatable {
    
    public static func == (lhs: State, rhs: State) -> Bool {
        return lhs.profile == rhs.profile && lhs.regions == rhs.regions
    }
}
