//
//  EventsConfiguration.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct EventsConfiguration {
    public var maxBatchSize: Int
    public var maxQueueSize: Int
    public var minBatchSize: Int
    public var flushInterval: Double
    
    public init(minBatchSize: Int, maxBatchSize: Int, maxQueueSize: Int, flushInterval: Double) {
        self.minBatchSize = minBatchSize
        self.maxBatchSize = maxBatchSize
        self.maxQueueSize = maxQueueSize
        self.flushInterval = flushInterval
    }
}
