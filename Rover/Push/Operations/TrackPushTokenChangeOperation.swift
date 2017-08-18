//
//  TrackPushTokenChangeOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class TrackPushTokenChangeOperation: Operation {
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
        super.init()
        self.name = "Track Push Token Change"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let currentToken = resolver.currentState.context.pushToken
        let timestamp = Date()
        
        if let previousToken = userDefaults.string(forKey: "io.rover.deviceToken") {
            let attributes: Attributes = ["previousToken": previousToken]
            
            if currentToken == nil {
                let operation = TrackEventOperation(eventName: "Device Token Removed", attributes: attributes, timestamp: timestamp)
                addOperation(operation)
            } else if currentToken != previousToken {
                let operation = TrackEventOperation(eventName: "Device Token Updated", attributes: attributes, timestamp: timestamp)
                addOperation(operation)
            }
        } else if currentToken != nil {
            let operation = TrackEventOperation(eventName: "Device Token Added", attributes: nil, timestamp: timestamp)
            addOperation(operation)
        }
        
        userDefaults.set(currentToken, forKey: "io.rover.deviceToken")
        completionHandler()
    }
}
