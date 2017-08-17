//
//  BorderViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol BorderViewModel {
    var border: Border { get }
    var borderColor: CGColor { get }
    var borderWidth: CGFloat { get }
    
    func cornerRadius(inFrame frame: CGRect) -> CGFloat
}

extension BorderViewModel {
    
    var borderColor: CGColor {
        return UIColor(color: border.borderColor).cgColor
    }
    
    var borderWidth: CGFloat {
        return CGFloat(border.borderWidth)
    }
    
    func cornerRadius(inFrame frame: CGRect) -> CGFloat {
        let borderRadius = CGFloat(border.borderRadius)
        let maxRadius = min(frame.height, frame.width) / 2
        return min(borderRadius, maxRadius)
    }
}
