//
//  Bundle.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol BundleProtocol {
    var infoDictionary: [String: Any]? { get }
    var localizedInfoDictionary: [String: Any]? { get }
    var bundleIdentifier: String? { get }
    
    init?(identifier: String)
}

extension Bundle: BundleProtocol { }
