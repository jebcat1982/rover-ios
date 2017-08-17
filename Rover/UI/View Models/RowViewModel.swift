//
//  RowViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

struct RowViewModel {
    var row: Row
}

extension RowViewModel {
    
    var blockViewModels: [BlockViewModel] {
        return row.blocks.map({ block in
            switch block {
            case let block as BarcodeBlock:
                return BarcodeBlockViewModel(barcodeBlock: block)
            case let block as ButtonBlock:
                return ButtonBlockViewModel(buttonBlock: block)
            case let block as ImageBlock:
                return ImageBlockViewModel(imageBlock: block)
            case let block as RectangleBlock:
                return RectangleBlockViewModel(rectangleBlock: block)
            case let block as TextBlock:
                return TextBlockViewModel(textBlock: block)
            case let block as WebViewBlock:
                return WebViewBlockViewModel(webViewBlock: block)
            default:
                return nil
            }
        }).flatMap({ $0 })
    }
    
    func frame(inBounds bounds: CGRect) -> CGRect {
        let x = bounds.origin.x
        let y = bounds.origin.y
        let width = bounds.width
        let height = self.height(inBounds: bounds)
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func height(inBounds bounds: CGRect) -> CGFloat {
        if row.autoHeight {
            let zero: CGFloat = 0
            return blockViewModels.reduce(zero) { $0 + $1.stackedHeight(inBounds: bounds) }
        }
        
        return row.height.measured(against: bounds.height)
    }
}

// MARK: BackgroundViewModel

extension RowViewModel: BackgroundViewModel {
    
    var background: Background {
        return row
    }
}
