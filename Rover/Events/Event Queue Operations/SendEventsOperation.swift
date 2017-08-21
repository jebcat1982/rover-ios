//
//  SendEventsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class SendEventsOperation: QueryOperation<SendEventsQuery> {
    
    init(events: [Event]) {
        let query = SendEventsQuery(events: events)
        super.init(query: query)
        self.credentials = events.first?.credentials
        self.name = "Send Events"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        delegate?.debug("Uploading \(query.events.count) event(s) to server", operation: self)
        super.execute(reducer: reducer, resolver: resolver, completionHandler: completionHandler)
    }
    
    override func handleResponse(_ response: SendEventsResponse, reducer: Reducer, resolver: Resolver) {
        delegate?.debug("Successfully uploaded \(query.events.count) event(s)", operation: self)
        removeEvents(reducer: reducer)
    }
    
    override func handleError(error: Error?, shouldRetry: Bool, reducer: Reducer, resolver: Resolver) {
        let nextSteps = shouldRetry ? "Will retry" : "Discarding events"
        delegate?.error("Failed to upload events: \(nextSteps)", operation: self)
        
        if !shouldRetry {
            removeEvents(reducer: reducer)
        }
    }
    
    func removeEvents(reducer: Reducer) {
        reducer.reduce { state in
            var nextQueue = state.eventQueue
            
            nextQueue.events = nextQueue.events.filter { event in
                !query.events.contains() { $0.uuid == event.uuid }
            }
            
            delegate?.debug("Removed \(query.events.count) event(s) from queue – queue now contains \(nextQueue.events.count) event(s)", operation: self)
            
            var nextState = state
            nextState.eventQueue = nextQueue
            return nextState
        }
    }
}

// MARK: SendEventsQuery

struct SendEventsQuery: GraphQLQuery {
    typealias Response = SendEventsResponse
    
    var events: [Event]
    
    var operationName: String? {
        return "TrackEvents"
    }
    
    var query: String {
        return """
        mutation {
        TrackEvents($events: [Event]!) {
        trackEvents(events: $events)
        }
        }
        """
    }
    
    var variables: Encodable? {
        return [
            "events": [events]
        ]
    }
}

// MARK: SendEventsResponse

struct SendEventsResponse: Decodable { }
