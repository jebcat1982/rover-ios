//
//  Rover.swift
//  Rover
//
//  Created by Sean Rucker on 2017-03-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

import RoverEvents
import RoverFoundation
import RoverHTTP
import RoverPush
import RoverSync
import RoverUser

public class Rover {
    
    static var sharedInstance: Rover?
    
    public static var shared: Rover {
        guard let sharedInstance = sharedInstance else {
            fatalError("Shared instance accessed before calling assemble")
        }
        
        return sharedInstance
    }
    
    @discardableResult public static func assemble(accountToken: String) -> Rover {
        let plugins: [Plugin] = [
            HTTPPlugin(accountToken: accountToken),
            EventsPlugin(),
            SyncPlugin(),
            UserPlugin(),
            PushPlugin()
        ]
        
        let container = Container(plugins: plugins)
        let rover = Rover(container: container)
        sharedInstance = rover
        return rover
    }
    
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
}

// MARK: Events

extension Rover {
    
    public func trackEvent(name: String, attributes: Attributes? = nil) {
        let operation = TrackEventOperation(name: name, attributes: attributes)
        container.addOperation(operation)
    }
}

// MARK: Push

extension Rover {
    
    public func captureDeviceToken(_ tokenData: Data) {
        let operation = CaptureDeviceTokenOperation(tokenData: tokenData)
        container.addOperation(operation)
    }
    
    public func removeDeviceToken() {
        let operation = RemoveDeviceTokenOperation()
        container.addOperation(operation)
    }
}

// MARK: Sync

extension Rover {
    
    public var currentUser: User? {
        return container.resolve(SyncPlugin.self)?.user
    }
    
    public func sync(completionHandler: (() -> Void)?) {
        let operation = SyncOperation()
        container.addOperation(operation) { _ in
            completionHandler?()
        }
    }
}

// MARK: User 

extension Rover {

    public func anonymizeUser() {
        let operation = AnonymizeUserOperation()
        container.addOperation(operation)
    }
    
    public func identifyUser(userID: UserID) {
        let operation = IdentifyUserOperation(userID: userID)
        container.addOperation(operation)
    }
    
    public func updateUser(updates: [UserUpdate], completionHandler: ((User?) -> Void)?) {
        let operation = UpdateUserOperation(updates: updates)
        container.addOperation(operation) { _ in
            completionHandler?(self.currentUser)
        }
    }
}
