//
//  AddTimeZoneToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddTimeZoneToContextOperation: Operation {
    let timeZone: NSTimeZoneProtocol
    
    init(timeZone: NSTimeZoneProtocol = NSTimeZone.local as NSTimeZone) {
        self.timeZone = timeZone
        super.init()
        self.name = "Add Time Zone To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            nextContext.timeZone = timeZone.name
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
