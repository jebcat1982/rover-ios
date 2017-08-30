//
//  AddPushTokenOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddPushTokenOperation: Operation {
    let data: Data
    
    init(data: Data) {
        self.data = data
        super.init()
        self.name = "Add Push Token"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let pushToken = data.map { String(format: "%02.2hhx", $0) }.joined()
        delegate?.debug("Setting pushToken to: \(pushToken)", operation: self)
        
        reducer.reduce { state in
            var nextContext = state.context
            nextContext.pushToken = pushToken
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        let operation = TrackPushTokenChangeOperation()
        addOperation(operation)
        completionHandler()
    }
}
