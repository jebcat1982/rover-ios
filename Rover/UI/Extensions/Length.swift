//
//  Length.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

extension Length {
    
    func measured(against value: Double) -> Double {
        switch unit {
        case .percentage:
            return self.value * value
        case .points:
            return self.value
        }
    }
    
    func measured(against value: CGFloat) -> CGFloat {
        switch unit {
        case .percentage:
            return CGFloat(self.value) * value
        case .points:
            return CGFloat(self.value)
        }
    }
}
