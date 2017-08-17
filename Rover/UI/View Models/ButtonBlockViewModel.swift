//
//  ButtonBlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct ButtonBlockViewModel {
    var buttonBlock: ButtonBlock
    var currentState: ButtonState
    
    init(buttonBlock: ButtonBlock) {
        self.buttonBlock = buttonBlock
        self.currentState = buttonBlock.normal
    }
}

// MARK: BlockViewModel

extension ButtonBlockViewModel: BlockViewModel {
    
    var cellReuseIdentifer: String {
        return ButtonBlockView.defaultReuseIdentifier
    }
    
    var block: Block {
        return buttonBlock
    }
}

// MARK: BackgroundViewModel

extension ButtonBlockViewModel: BackgroundViewModel {
    
    var background: Background {
        return currentState
    }
}

// MARK: BorderViewModel

extension ButtonBlockViewModel: BorderViewModel {
    
    var border: Border {
        return currentState
    }
}

// MARK: TextViewModel

extension ButtonBlockViewModel: TextViewModel {
    
    var textModel: Text {
        return currentState
    }
}
