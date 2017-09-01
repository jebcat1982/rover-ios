//
//  SendEventsQuery.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct SendEventsQuery: HTTPQuery {
    typealias Response = String
    
    var events: [Event]
    var context: Context
    
    var operationName: String? {
        return "SendEvents"
    }
    
    var query: String {
        return """
            mutation {
                SendEvents($events: [Event]!, $context: Context) {
                    sendEvents(events: $events, context: $context)
                }
            }
            """
    }
    
    var variables: Encodable? {
        return [
            "events": events,
            "context": context
        ]
    }
}
