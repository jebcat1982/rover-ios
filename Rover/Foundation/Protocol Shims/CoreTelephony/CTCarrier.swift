//
//  CTCarrier.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreTelephony

public protocol CTCarrierProtocol {
    var carrierName: String? { get }
}

extension CTCarrier: CTCarrierProtocol { }
