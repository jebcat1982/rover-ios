//
//  LocationContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

struct LocationContextProvider {
    let locationManagerType: CLLocationManagerProtocol.Type
}

extension LocationContextProvider: ContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        let authorizationStatus: String
        switch locationManagerType.authorizationStatus() {
        case .authorizedAlways:
            authorizationStatus = "authorizedAlways"
        case .authorizedWhenInUse:
            authorizationStatus = "authorizedWhenInUse"
        case .denied:
            authorizationStatus = "denied"
        case .notDetermined:
            authorizationStatus = "notDetermined"
        case .restricted:
            authorizationStatus = "restricted"
        }
        
        logger.debug("Setting locationAuthorization to: \(authorizationStatus)")
        nextContext.locationAuthorization = authorizationStatus
        
        let locationServicesEnabled = locationManagerType.locationServicesEnabled()
        logger.debug("Setting isLocationServicesEnabled to: \(locationServicesEnabled)")
        nextContext.isLocationServicesEnabled = locationServicesEnabled
        
        return nextContext
    }
}
