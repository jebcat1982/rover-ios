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
        
        let container = Container()
        container.register(plugins)
        
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
        container.trackEvent(name: name, attributes: attributes)
    }
}

// MARK: Push

extension Rover {
    
    public func addDeviceToken(_ data: Data) {
        container.addDeviceToken(data)
    }
    
    public func removeDeviceToken() {
        container.removeDeviceToken()
    }
}

// MARK: Sync

extension Rover {
    
    public var currentUser: User? {
        return container.resolve(SyncPlugin.self).user
    }
    
    public func sync(completionHandler: (() -> Void)?) {
        container.sync(completionHandler: completionHandler)
    }
}

// MARK: User 

extension Rover {

    public func anonymizeUser() {
        container.anonymize()
    }
    
    public func identifyUser(userID: UserID) {
        container.identify(userID: userID)
    }
    
    public func updateUser(updates: [UserUpdate], completionHandler: ((User?) -> Void)?) {
        
    }
}
