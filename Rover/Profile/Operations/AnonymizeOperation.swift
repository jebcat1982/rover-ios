//
//  AnonymizeOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AnonymizeOperation: ContainerOperation {
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
        let operations = [
            RemoveProfileIDFromCredentialsOperation()
        ]
        super.init(operations: operations)
        self.name = "Anonymize"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        userDefaults.removeObject(forKey: "io.rover.profileID")
        completionHandler()
    }
}
