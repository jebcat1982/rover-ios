//
//  TimeZoneContextPluginTests.swift
//  Rover
//
//  Created by Sean Rucker on 2017-02-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import XCTest

@testable import Rover

class TimeZoneContextPluginTest: XCTestCase {
    
    func testCapture() {
        
        struct TestTimeZone: TimeZoneType {
            var name: String
        }
        
        let timeZone = TestTimeZone(name: "America/Santiago")
        let context = TimeZoneContextPlugin(timeZone: timeZone).captureContext(Context())
        
        XCTAssertEqual(context["timeZone"] as! String, "America/Santiago")
    }
}
