//
//  EventQueue.swift
//  Rover
//
//  Created by Sean Rucker on 2017-02-13.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation
import RoverData

struct EventQueue {
    
    let maxBatchSize: Int
    
    let maxQueueSize: Int
    
    var events = [Event]()
}

extension EventQueue {
    
    var count: Int {
        return events.count
    }
    
    init(maxBatchSize: Int, maxQueueSize: Int) {
        self.maxBatchSize = maxBatchSize
        self.maxQueueSize = maxQueueSize
    }
    
    mutating func add(event: Event) {
        if events.count == maxQueueSize {
            events.remove(at: 0)
        }
        
        events.append(event)
    }
    
    mutating func remove(batch: EventBatch) {
        events = events.filter { event in
            return !batch.contains(event)
        }
    }
    
    func nextBatch(minSize: Int) -> EventBatch? {
        guard events.count > 0, events.count >= minSize else {
            return nil
        }
        
        let authHeaders = events.first?.authHeaders
        var nextEvents = [Event]()
        
        for (offset, event) in events.enumerated() {
            guard offset < maxBatchSize else {
                break
            }
            
            if let authHeaders = authHeaders {
                guard let eventHeaders = event.authHeaders, eventHeaders == authHeaders else {
                    break
                }
            } else {
                guard event.authHeaders == nil else {
                    break
                }
            }
            
            nextEvents.append(event)
        }
        
        
        return EventBatch(events: nextEvents, authHeaders: authHeaders)
    }
}
