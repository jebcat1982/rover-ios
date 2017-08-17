//
//  TextBlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

struct TextBlockViewModel {
    var textBlock: TextBlock
}

// MARK: BlockViewModel

extension TextBlockViewModel: BlockViewModel {
    
    var cellReuseIdentifer: String {
        return TextBlockView.defaultReuseIdentifier
    }
    
    var block: Block {
        return textBlock
    }
    
    func intrinsicHeight(inBounds bounds: CGRect) -> CGFloat {
        guard let attributedText = self.attributedText else {
            return 0
        }
        
        let width = self.width(inBounds: bounds) - insets.left + insets.right
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = attributedText.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return boundingRect.height + insets.top - insets.bottom
    }
}

// MARK: BackgroundViewModel

extension TextBlockViewModel: BackgroundViewModel {
    
    var background: Background {
        return textBlock
    }
}

// MARK: BorderViewModel

extension TextBlockViewModel: BorderViewModel {
    
    var border: Border {
        return textBlock
    }
}

// MARK: TextViewModel

extension TextBlockViewModel: TextViewModel {
    
    var textModel: Text {
        return textBlock
    }
}
