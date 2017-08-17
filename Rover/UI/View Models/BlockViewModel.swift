//
//  BlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol BlockViewModel {
    var block: Block { get }
    var cellReuseIdentifer: String { get }
    
    func intrinsicHeight(inBounds bounds: CGRect) -> CGFloat
}

extension BlockViewModel {
    
    var action: BlockAction? {
        return block.action
    }
    
    var cellReuseIdentifer: String {
        return BlockView.defaultReuseIdentifier
    }
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(
            top: CGFloat(block.insets.top),
            left: CGFloat(block.insets.left),
            bottom: 0 - CGFloat(block.insets.bottom),
            right: 0 - CGFloat(block.insets.right)
        )
    }
    
    var isStacked: Bool {
        return block.position == .stacked
    }
    
    var opacity: Float {
        return Float(block.opacity)
    }
    
    var verticalAlignment: UIControlContentVerticalAlignment {
        switch block.verticalAlignment {
        case .bottom:
            return .bottom
        case .fill:
            return .fill
        case .middle:
            return .center
        case .top:
            return .top
        }
    }
    
    func frame(inBounds bounds: CGRect) -> CGRect {
        let x = self.x(inBounds: bounds)
        let y = self.y(inBounds: bounds)
        let width = self.width(inBounds: bounds)
        let height = self.height(inBounds: bounds)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func height(inBounds bounds: CGRect) -> CGFloat {
        switch block.verticalAlignment {
        case .fill:
            let top = block.offsets.top.measured(against: bounds.height)
            let bottom = block.offsets.bottom.measured(against: bounds.height)
            return bounds.height - top - bottom
        default:
            return block.autoHeight ? self.intrinsicHeight(inBounds: bounds) : block.height.measured(against: bounds.height)
        }
    }
    
    func intrinsicHeight(inBounds bounds: CGRect) -> CGFloat {
        return 0
    }
    
    func stackedHeight(inBounds bounds: CGRect) -> CGFloat {
        guard block.position == .stacked else {
            return 0
        }
        
        return self.height(inBounds: bounds) + CGFloat(block.offsets.top.value) + CGFloat(block.offsets.bottom.value)
    }
    
    func width(inBounds bounds: CGRect) -> CGFloat {
        var width: CGFloat!
        
        switch block.horizontalAlignment {
        case .fill:
            let left = block.offsets.left.measured(against: bounds.width)
            let right = block.offsets.right.measured(against: bounds.width)
            width = bounds.width - left - right
        default:
            width = block.width.measured(against: bounds.width)
        }
        
        return max(width, 0)
    }
    
    func x(inBounds bounds: CGRect) -> CGFloat {
        let width = self.width(inBounds: bounds)
        
        switch block.horizontalAlignment {
        case .center:
            return bounds.origin.x + ((bounds.width - width) / 2) + block.offsets.center.measured(against: bounds.width)
        case .fill, .left:
            return bounds.origin.x + block.offsets.left.measured(against: bounds.width)
        case .right:
            return bounds.origin.x + bounds.width - width - block.offsets.right.measured(against: bounds.width)
        }
    }
    
    func y(inBounds bounds: CGRect) -> CGFloat {
        let height = self.height(inBounds: bounds)
        
        switch block.verticalAlignment {
        case .bottom:
            return bounds.origin.y + bounds.height - height - block.offsets.bottom.measured(against: bounds.height)
        case .fill, .top:
            return bounds.origin.y + block.offsets.top.measured(against: bounds.height)
        case .middle:
            return bounds.origin.y + ((bounds.height - height) / 2) + block.offsets.middle.measured(against: bounds.height)
        }
    }
}
