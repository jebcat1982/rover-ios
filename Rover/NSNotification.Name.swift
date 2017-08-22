//
//  NSNotification.Name.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-22.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public extension NSNotification.Name {
    static let RoverDidUpdateProfile = NSNotification.Name(rawValue: "RoverDidUpdateProfile")
    static let RoverDidUpdateRegions = NSNotification.Name(rawValue: "RoverDidUpdateRegions")
}
