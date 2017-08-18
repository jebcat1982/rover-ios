//
//  IdentifyOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class IdentifyOperation: Operation {
    let identifier: String
    let userDefaults: UserDefaultsProtocol
    
    init(identifier: String, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.identifier = identifier
        self.userDefaults = userDefaults
        let operations = [
            AddProfileIDToCredentialsOperation(identifier: identifier)
        ]
        super.init(operations: operations)
        self.name = "Identify"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        userDefaults.set(identifier, forKey: "io.rover.profileIdentifier")
        completionHandler()
    }
}
