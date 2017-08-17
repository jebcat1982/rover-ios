//
//  UIStatusBarStyle.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

extension UIStatusBarStyle {
    
    init(statusBarStyle: StatusBarStyle) {
        switch statusBarStyle {
        case .dark:
            self = .default
        case .light:
            self = .lightContent
        }
    }
}
