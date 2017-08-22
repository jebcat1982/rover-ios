//
//  RestoreProfileIdentifierFromUserDefaultsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class RestoreProfileIdentifierFromUserDefaultsOperation: Operation {
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
        super.init()
        self.name = "Restore Profile Identifier From UserDefaults"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        guard let identifier = userDefaults.string(forKey: "io.rover.profileIdentifier") else {
            delegate?.debug("No profile identifier found in UserDefaults", operation: self)
            completionHandler()
            return
        }
        
        delegate?.debug("Found profile identifier: \(identifier)", operation: self)
        
        let operation = AddProfileIdentifierToCredentialsOperation(identifier: identifier)
        addOperation(operation)
        completionHandler()
    }
}
