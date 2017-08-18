//
//  RestoreProfileIDFromUserDefaultsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class RestoreProfileIDFromUserDefaultsOperation: Operation {
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
        super.init()
        self.name = "Restore Profile ID From UserDefaults"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        guard let identifier = userDefaults.string(forKey: "io.rover.profileIdentifier") else {
            delegate?.debug("No profile identifier found in UserDefaults", operation: self)
            completionHandler()
            return
        }
        
        let operation = AddProfileIDToCredentialsOperation(identifier: identifier)
        addOperation(operation)
        completionHandler()
    }
}
