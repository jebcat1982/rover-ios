//
//  TrackPushTokenChangeOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-16.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class TrackPushTokenChangeOperation: Operation {
    static let pushTokenKey = "io.rover.pushToken"
    
    let timestamp: Date
    let userDefaults: UserDefaultsProtocol
    
    init(timestamp: Date = Date(), userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.timestamp = timestamp
        self.userDefaults = userDefaults
        super.init()
        self.name = "Track Push Token Change"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        let currentToken = resolver.currentState.context.pushToken
        let previousToken = userDefaults.string(forKey: TrackPushTokenChangeOperation.pushTokenKey)
        
        switch (currentToken, previousToken) {
        case (let currentToken?, let previousToken?):
            delegate?.debug("Current token: \(currentToken)", operation: self)
            delegate?.debug("Previous token: \(previousToken)", operation: self)
            if currentToken != previousToken {
                delegate?.debug("Current and previous tokens do not match – push token updated", operation: self)
                let attributes: Attributes = ["currentToken": currentToken, "previousToken": previousToken]
                let operation = TrackEventOperation(eventName: "Update Push Token", attributes: attributes, timestamp: timestamp)
                addOperation(operation)
            } else {
                delegate?.debug("Current and previous tokens match – nothing to track", operation: self)
            }
        case (let currentToken?, _):
            delegate?.debug("Current token: \(currentToken)", operation: self)
            delegate?.debug("Previous token not found - push token added", operation: self)
            let attributes: Attributes = ["currentToken": currentToken]
            let operation = TrackEventOperation(eventName: "Add Push Token", attributes: attributes, timestamp: timestamp)
            addOperation(operation)
        case (_, let previousToken?):
            delegate?.debug("Previous token: \(previousToken)", operation: self)
            delegate?.debug("Current token not found – push token removed", operation: self)
            let attributes: Attributes = ["previousToken": previousToken]
            let operation = TrackEventOperation(eventName: "Remove Push Token", attributes: attributes, timestamp: timestamp)
            addOperation(operation)
        default:
            delegate?.debug("Current and previous tokens are both nil – nothing to track", operation: self)
        }
        
        userDefaults.set(currentToken, forKey: TrackPushTokenChangeOperation.pushTokenKey)
        completionHandler()
    }
}
