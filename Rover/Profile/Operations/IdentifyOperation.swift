//
//  IdentifyOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class IdentifyOperation: Operation {
    let profileID: ID
    let userDefaults: UserDefaultsProtocol
    
    init(profileID: ID, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.profileID = profileID
        self.userDefaults = userDefaults
        let operations = [
            AddProfileIDToCredentialsOperation(profileID: profileID)
        ]
        super.init(operations: operations)
        self.name = "Identify"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        userDefaults.set(profileID, forKey: "io.rover.profileID")
        completionHandler()
    }
}
