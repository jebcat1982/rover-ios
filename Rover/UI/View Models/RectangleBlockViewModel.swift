//
//  RectangleBlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct RectangleBlockViewModel {
    var rectangleBlock: RectangleBlock
}

// MARK: BlockViewModel

extension RectangleBlockViewModel: BlockViewModel {
    
    var cellReuseIdentifer: String {
        return RectangleBlockView.defaultReuseIdentifier
    }
    
    var block: Block {
        return rectangleBlock
    }
}

// MARK: BackgroundViewModel

extension RectangleBlockViewModel: BackgroundViewModel {
    
    var background: Background {
        return rectangleBlock
    }
}

// MARK: BorderViewModel

extension RectangleBlockViewModel: BorderViewModel {
    
    var border: Border {
        return rectangleBlock
    }
}
