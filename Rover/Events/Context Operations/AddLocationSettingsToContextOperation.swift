//
//  AddLocationSettingsToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

class AddLocationSettingsToContextOperation: ContainerOperation {
    let locationManagerType: CLLocationManagerProtocol.Type
    
    init(locationManagerType: CLLocationManagerProtocol.Type = CLLocationManager.self) {
        self.locationManagerType = locationManagerType
        super.init()
        self.name = "Add Location Authorization To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            switch locationManagerType.authorizationStatus() {
            case .authorizedAlways:
                nextContext.locationAuthorization = "authorizedAlways"
            case .authorizedWhenInUse:
                nextContext.locationAuthorization = "authorizedWhenInUse"
            case .denied:
                nextContext.locationAuthorization = "denied"
            case .notDetermined:
                nextContext.locationAuthorization = "notDetermined"
            case .restricted:
                nextContext.locationAuthorization = "restricted"
            }
            
            nextContext.isLocationServicesEnabled = locationManagerType.locationServicesEnabled()
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
