//
//  AddTelephonyInfoToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import CoreTelephony

class AddTelephonyInfoToContextOperation: Operation {
    let telephonyNetworkInfo: CTTelephonyNetworkInfoProtocol
    let carrier: CTCarrierProtocol?
    
    var currentRadio: String? {
        var radio = telephonyNetworkInfo.currentRadioAccessTechnology
        let prefix = "CTRadioAccessTechnology"
        if radio == nil {
            radio = "None"
        } else if radio!.hasPrefix(prefix) {
            radio = (radio! as NSString).substring(from: prefix.characters.count)
        }
        return radio
    }
    
    init(telephonyNetworkInfo: CTTelephonyNetworkInfoProtocol? = nil, carrier: CTCarrierProtocol? = nil) {
        switch (telephonyNetworkInfo, carrier) {
        case let (telephonyNetworkInfo?, carrier?):
            self.telephonyNetworkInfo = telephonyNetworkInfo
            self.carrier = carrier
        case (_, let carrier?):
            self.telephonyNetworkInfo = CTTelephonyNetworkInfo()
            self.carrier = carrier
        case (let telephonyNetworkInfo?, _):
            self.telephonyNetworkInfo = telephonyNetworkInfo
            self.carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
        case (_, _):
            let telephonyNetworkInfo = CTTelephonyNetworkInfo()
            self.telephonyNetworkInfo = telephonyNetworkInfo
            self.carrier = telephonyNetworkInfo.subscriberCellularProvider
        }
        super.init()
        self.name = "Add Telephony Info To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            if let carrierName = carrier?.carrierName {
                delegate?.debug("Setting carrierName to: \(carrierName)", operation: self)
                nextContext.carrierName = carrierName
            } else {
                delegate?.warn("Failed to capture carrier name – this is expected behaviour if you are running a simulator", operation: self)
                nextContext.carrierName = nil
            }
            
            if let radio = currentRadio {
                delegate?.debug("Setting radio to: \(radio)", operation: self)
                nextContext.radio = radio
            } else {
                delegate?.warn("Failed to capture radio", operation: self)
                nextContext.radio = nil
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
