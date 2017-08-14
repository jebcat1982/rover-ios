//
//  RestoreProfileIDFromUserDefaultsOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class RestoreProfileIDFromUserDefaultsOperation: ContainerOperation {
    let userDefaults: UserDefaultsProtocol
    
    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
        super.init()
        self.name = "Restore Profile ID From UserDefaults"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        guard let profileID = userDefaults.string(forKey: "io.rover.profileID").map({ ID(rawValue: $0) }) else {
            logger.debug("No profile ID found in UserDefaults")
            completionHandler()
            return
        }
        
        let operation = AddProfileIDToCredentialsOperation(profileID: profileID)
        addOperation(operation)
        completionHandler()
    }
}
