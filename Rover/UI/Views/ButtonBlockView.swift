//
//  ButtonBlockView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ButtonBlockView: BlockView {
    
    override var content: UIView? {
        return label
    }
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var configuration: (ButtonBlockViewModel, CGRect)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addLongPressGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with blockViewModel: BlockViewModel, inFrame frame: CGRect) {
        super.configure(with: blockViewModel, inFrame: frame)
        
        guard let buttonBlockViewModel = blockViewModel as? ButtonBlockViewModel else {
            label.isHidden = true
            configuration = nil
            return
        }
        
        label.isHidden = false
        label.text = buttonBlockViewModel.text
        label.textColor = buttonBlockViewModel.textColor
        label.textAlignment = buttonBlockViewModel.textAlignment
        label.font = buttonBlockViewModel.font
        
        configuration = (buttonBlockViewModel, frame)
    }
    
    func addLongPressGestureRecognizer() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gestureRecognizer.minimumPressDuration = 0
        gestureRecognizer.delegate = self
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        guard let configuration = configuration else {
            return
        }
        
        switch gestureRecognizer.state {
        case .began:
            var highlightedViewModel = configuration.0
            highlightedViewModel.currentState = highlightedViewModel.buttonBlock.highlighted
            configure(with: highlightedViewModel as BlockViewModel, inFrame: configuration.1)
        case .ended:
            var normalViewModel = configuration.0
            normalViewModel.currentState = normalViewModel.buttonBlock.normal
            configure(with: normalViewModel as BlockViewModel, inFrame: configuration.1)
        default:
            break
        }
    }
}

extension ButtonBlockView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
