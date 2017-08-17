//
//  ScreenViewLayoutAttributes.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ScreenViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var referenceFrame = CGRect.zero
    var verticalAlignment = UIControlContentVerticalAlignment.top
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        
        guard let attributes = copy as? ScreenViewLayoutAttributes else {
            return copy
        }
        
        attributes.referenceFrame = referenceFrame
        attributes.verticalAlignment = verticalAlignment
        return attributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? ScreenViewLayoutAttributes else {
            return false
        }
        
        return super.isEqual(object) && referenceFrame == rhs.referenceFrame && verticalAlignment == rhs.verticalAlignment
    }
}
