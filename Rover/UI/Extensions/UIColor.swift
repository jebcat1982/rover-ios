//
//  UIColor.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(color: Color) {
        let red = CGFloat(color.red) / 255.0
        let green = CGFloat(color.green) / 255.0
        let blue = CGFloat(color.blue) / 255.0
        let alpha = CGFloat(color.alpha)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
