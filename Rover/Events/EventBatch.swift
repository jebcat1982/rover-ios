//
//  EventBatch.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct EventBatch {
    var events: [Event]
    var context: Context
    var credentials: Credentials
    
    init(events: [Event] = [Event](), context: Context, credentials: Credentials) {
        self.events = events
        self.context = context
        self.credentials = credentials
    }
}
