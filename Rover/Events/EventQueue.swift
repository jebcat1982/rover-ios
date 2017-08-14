//
//  EventQueue.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct EventQueue {
    var flushAt = 20
    var maxBatchSize = 100
    var maxQueueSize = 1000
    var events = [Event]()
}
