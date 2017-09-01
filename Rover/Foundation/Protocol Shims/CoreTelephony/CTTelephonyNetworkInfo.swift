//
//  CTTelephonyNetworkInfo.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreTelephony

public protocol CTTelephonyNetworkInfoProtocol {
    var currentRadioAccessTechnology: String? { get }
}

extension CTTelephonyNetworkInfo: CTTelephonyNetworkInfoProtocol { }
