//
//  RemovePushTokenOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class RemovePushTokenOperation: Operation {
    
    init() {
        super.init()
        self.name = "Remove Push Token"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            nextContext.pushToken = nil
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        let operation = TrackPushTokenChangeOperation()
        addOperation(operation)
        completionHandler()
    }
}
