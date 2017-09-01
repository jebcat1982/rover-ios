//
//  TimeZoneContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct TimeZoneContextProvider {
    let timeZone: NSTimeZoneProtocol
}

extension TimeZoneContextProvider: ContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        let timeZone = self.timeZone.name
        logger.debug("Setting timeZone to: \(timeZone)")
        nextContext.timeZone = timeZone
        
        return nextContext
    }
}
