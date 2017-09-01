//
//  EventQueue.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct EventQueue {
    var maxBatchSize: Int
    var maxQueueSize: Int
    var minBatchSize: Int
    
    var snapshots = [EventSnapshot]()
    var count: Int {
        return snapshots.count
    }
    
    init(minBatchSize: Int, maxBatchSize: Int, maxQueueSize: Int) {
        self.maxBatchSize = maxBatchSize
        self.maxQueueSize = maxQueueSize
        self.minBatchSize = minBatchSize
    }
}

extension EventQueue {
    
    mutating func addEvent(_ event: Event, context: Context, credentials: Credentials) {
        let snapshot = EventSnapshot(event: event, context: context, credentials: credentials)
        
        if snapshots.count == maxQueueSize {
            logger.debug("Event queue is at capacity (\(maxQueueSize)) – removing oldest event")
            snapshots.remove(at: 0)
        }
        
        snapshots.append(snapshot)
        logger.debug("Added 1 event to queue – queue now contains \(snapshots.count) event(s)")
    }
    
    mutating func removeEvents(_ events: [Event]) {
        snapshots = snapshots.filter { snapshot in
            !events.contains() { $0.uuid == snapshot.event.uuid }
        }
    }
    
    func nextBatch(minBatchSize: Int?) -> EventBatch? {
        let minBatchSize = minBatchSize ?? self.minBatchSize
        
        guard snapshots.count > 0, snapshots.count >= minBatchSize else {
            return nil
        }
        
        let firstSnapshot = snapshots.first!
        var batch = EventBatch(context: firstSnapshot.context, credentials: firstSnapshot.credentials)
        
        for (offset, snapshot) in snapshots.enumerated() {
            guard offset < maxBatchSize else {
                break
            }
            
            guard snapshot.credentials == batch.credentials else {
                break
            }
            
            batch.events.append(snapshot.event)
        }
        
        return batch
    }
}
