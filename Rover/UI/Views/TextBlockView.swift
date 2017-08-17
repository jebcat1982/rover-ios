//
//  TextBlockView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class TextBlockView: BlockView {

    override var content: UIView? {
        return textView
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        return textView
    }()
    
    override func configure(with blockViewModel: BlockViewModel, inFrame frame: CGRect) {
        super.configure(with: blockViewModel, inFrame: frame)
        
        guard let textBlockViewModel = blockViewModel as? TextBlockViewModel else {
            textView.attributedText = nil
            return
        }
        
        textView.attributedText = textBlockViewModel.attributedText
    }
}
