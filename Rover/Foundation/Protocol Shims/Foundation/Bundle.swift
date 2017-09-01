//
//  Bundle.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public protocol BundleProtocol {
    var infoDictionary: [String: Any]? { get }
    var localizedInfoDictionary: [String: Any]? { get }
    var bundleIdentifier: String? { get }
    
    init?(identifier: String)
    
    func path(forResource name: String?, ofType ext: String?) -> String?
}

extension Bundle: BundleProtocol { }
