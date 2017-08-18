//
//  PersistEventsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class PersistEventsOperation: Operation {
    
    init() {
        super.init()
        self.name = "Persist Events"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        // TODO: Persist events
        completionHandler()
    }
}
