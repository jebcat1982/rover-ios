//
//  Profile.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct Profile: Codable {
    public var id: ID?
    public var attributes = Attributes()
}
