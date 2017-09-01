//
//  ReachabilityContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct ReachabilityContextProvider {
    let reachability: ReachabilityProtocol
}

extension ReachabilityContextProvider: ContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        let isWifiEnabled = reachability.isReachableViaWiFi
        logger.debug("Setting isWifiEnabled to: \(isWifiEnabled)")
        nextContext.isWifiEnabled = isWifiEnabled
        
        let isCellularEnabled = reachability.isReachableViaWWAN
        logger.debug("Setting isCellularEnabled to: \(isCellularEnabled)")
        nextContext.isCellularEnabled = isCellularEnabled
        
        return nextContext
    }
}
