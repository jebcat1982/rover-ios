//
//  AddScreenSizeToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class AddScreenSizeToContextOperation: Operation {
    let screen: UIScreenProtocol
    
    init(screen: UIScreenProtocol = UIScreen.main) {
        self.screen = screen
        super.init()
        self.name = "Add Screen Size To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            let screenHeight = Int(screen.bounds.height)
            delegate?.debug("Setting screenHeight to: \(screenHeight)", operation: self)
            nextContext.screenHeight = screenHeight
            
            let screenWidth = Int(screen.bounds.width)
            delegate?.debug("Setting screenWidth to: \(screenWidth)", operation: self)
            nextContext.screenWidth = screenWidth
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
