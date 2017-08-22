//
//  ApplicationState.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreLocation

struct ApplicationState {
    var dataClient = DataClient()
    var credentials = Credentials()
    var eventQueue = EventQueue()
    var context = Context()
    var profile = Profile()
    var experiences = ExperienceCache()
    var regions = Set<CLRegion>()
}
