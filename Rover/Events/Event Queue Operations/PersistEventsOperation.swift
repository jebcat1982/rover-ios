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
        // TODO: Persist event queue to disk – https://github.com/RoverPlatform/rover-ios/issues/148
        delegate?.debug("TODO: Persist event queue to disk - https://github.com/RoverPlatform/rover-ios/issues/148", operation: self)
        completionHandler()
    }
}
