//
//  FlushEventsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class FlushEventsOperation: Operation {
    let minBatchSize: Int?
    
    init(minBatchSize: Int? = nil) {
        self.minBatchSize = minBatchSize
        super.init()
        self.name = "Flush Events"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let eventQueue = resolver.currentState.eventQueue
        let minBatchSize = self.minBatchSize ?? eventQueue.flushAt
        
        guard let batch = nextBatch(events: eventQueue.events, minSize: minBatchSize, maxBatchSize: eventQueue.maxBatchSize) else {
            logger.debug("Skipping flush – less than \(minBatchSize) events in the queue")
            completionHandler()
            return
        }
        
        addOperations([
            SendEventsOperation(events: batch),
            PersistEventsOperation()
            ])
        
        completionHandler()
    }
    
    func nextBatch(events: [Event], minSize: Int, maxBatchSize: Int) -> [Event]? {
        guard events.count > 0, events.count >= minSize else {
            return nil
        }
        
        let credentials = events.first?.credentials
        var nextEvents = [Event]()
        
        for (offset, event) in events.enumerated() {
            guard offset < maxBatchSize else {
                break
            }
            
            if let credentials = credentials {
                guard event.credentials == credentials else {
                    break
                }
            }
            
            nextEvents.append(event)
        }
        
        return nextEvents
    }
}
