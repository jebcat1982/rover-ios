//
//  AddReachabilityInfoToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class AddReachabilityInfoToContextOperation: Operation {
    var reachability: ReachabilityProtocol?
    
    init(reachability: ReachabilityProtocol? = Reachability(hostname: "google.com")) {
        self.reachability = reachability
        super.init()
        self.name = "Add Reachability Info To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        guard let reachability = self.reachability else {
            delegate?.warn("Failed to initialize Reachability client", operation: self)
            completionHandler()
            return
        }
        
        reducer.reduce { state in
            var nextContext = state.context
            
            let isWifiEnabled = reachability.isReachableViaWiFi
            delegate?.debug("Setting isWifiEnabled to: \(isWifiEnabled)", operation: self)
            nextContext.isWifiEnabled = isWifiEnabled
            
            let isCellularEnabled = reachability.isReachableViaWWAN
            delegate?.debug("Setting isCellularEnabled to: \(isCellularEnabled)", operation: self)
            nextContext.isCellularEnabled = isCellularEnabled
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
