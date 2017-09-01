//
//  UIDevice.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

public protocol UIDeviceProtocol {
    var identifierForVendor: UUID? { get }
    var systemName: String { get }
    var systemVersion: String { get }
}

extension UIDevice: UIDeviceProtocol { }
