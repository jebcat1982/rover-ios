//
//  UIScreen.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol UIScreenProtocol {
    var bounds: CGRect { get }
}

extension UIScreen: UIScreenProtocol { }
