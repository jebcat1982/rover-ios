//
//  AddEventOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddEventOperation: Operation {
    let eventName: String
    let attributes: Attributes?
    let timestamp: Date
    
    init(eventName: String, attributes: Attributes?, timestamp: Date) {
        self.eventName = eventName
        self.attributes = attributes
        self.timestamp = timestamp
        super.init()
        self.name = "Add Event"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            let newEvent = Event(name: eventName, attributes: attributes, timestamp: timestamp, context: state.context, credentials: state.credentials)
            
            var nextQueue = state.eventQueue
            
            if nextQueue.events.count == nextQueue.maxQueueSize {
                delegate?.debug("Event queue is at capacity (\(nextQueue.maxQueueSize)) – removing oldest event", operation: self)
                nextQueue.events.remove(at: 0)
            }
            
            nextQueue.events.append(newEvent)
            delegate?.debug("Added 1 event to queue – queue now contains \(nextQueue.events.count) event(s)", operation: self)
            
            var nextState = state
            nextState.eventQueue = nextQueue
            return nextState
        }
        
        completionHandler()
    }
}
