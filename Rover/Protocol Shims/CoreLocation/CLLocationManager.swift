//
//  CLLocationManager.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

protocol CLLocationManagerProtocol {
    static func authorizationStatus() -> CLAuthorizationStatus
    static func locationServicesEnabled() -> Bool
}

extension CLLocationManager: CLLocationManagerProtocol { }
