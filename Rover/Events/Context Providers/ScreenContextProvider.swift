//
//  ScreenContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

struct ScreenContextProvider {
    let screen: UIScreenProtocol
}

extension ScreenContextProvider: ContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        let screenHeight = Int(screen.bounds.height)
        logger.debug("Setting screenHeight to: \(screenHeight)")
        nextContext.screenHeight = screenHeight
        
        let screenWidth = Int(screen.bounds.width)
        logger.debug("Setting screenWidth to: \(screenWidth)")
        nextContext.screenWidth = screenWidth
        
        return nextContext
    }
}
