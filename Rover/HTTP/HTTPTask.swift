//
//  HTTPTask.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public protocol HTTPTask {
    func cancel()
    func resume()
}
