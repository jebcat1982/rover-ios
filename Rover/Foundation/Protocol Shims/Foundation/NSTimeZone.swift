//
//  NSTimeZone.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public protocol NSTimeZoneProtocol {
    var name: String { get }
}

extension NSTimeZone: NSTimeZoneProtocol { }
