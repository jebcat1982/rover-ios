//
//  ConfigureEventQueueOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class ConfigureEventQueueOperation: Operation {
    let flushAt: Int?
    let maxBatchSize: Int?
    let maxQueueSize: Int?
    
    init(flushAt: Int?, maxBatchSize: Int?, maxQueueSize: Int?) {
        self.flushAt = flushAt
        self.maxBatchSize = maxBatchSize
        self.maxQueueSize = maxQueueSize
        super.init()
        self.name = "Configure Event Queue"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextQueue = state.eventQueue
            
            if let flushAt = flushAt {
                nextQueue.flushAt = flushAt
            }
            
            if let maxBatchSize = maxBatchSize {
                nextQueue.maxBatchSize = maxBatchSize
            }
            
            if let maxQueueSize = maxQueueSize {
                nextQueue.maxQueueSize = maxQueueSize
            }
            
            var nextState = state
            nextState.eventQueue = nextQueue
            return nextState
        }
        
        completionHandler()
    }
}
