//
//  AddLocationSettingsToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

class AddLocationSettingsToContextOperation: Operation {
    let locationManagerType: CLLocationManagerProtocol.Type
    
    init(locationManagerType: CLLocationManagerProtocol.Type = CLLocationManager.self) {
        self.locationManagerType = locationManagerType
        super.init()
        self.name = "Add Location Settings To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
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
            
            delegate?.debug("Setting locationAuthorization to: \(authorizationStatus)", operation: self)
            nextContext.locationAuthorization = authorizationStatus
            
            let locationServicesEnabled = locationManagerType.locationServicesEnabled()
            delegate?.debug("Setting isLocationServicesEnabled to: \(locationServicesEnabled)", operation: self)
            nextContext.isLocationServicesEnabled = locationServicesEnabled
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
