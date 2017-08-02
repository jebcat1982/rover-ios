//
//  RoverTests.swift
//  Rover
//
//  Created by Sean Rucker on 2017-03-07.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import XCTest
import Foundation

@testable import Rover

class RoverTests: XCTestCase {

    func testAssemble() {
        Rover.assemble(accountToken: "foo")
        let _ = Rover.shared
    }
}
