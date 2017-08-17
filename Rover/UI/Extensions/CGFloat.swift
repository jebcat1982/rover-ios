//
//  CGFloat.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

extension CGFloat {
    
    var paramValue: String {
        let rounded = self.rounded()
        let int = Int(rounded)
        return int.description
    }
}
