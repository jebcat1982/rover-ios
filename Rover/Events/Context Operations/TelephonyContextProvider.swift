//
//  TelephonyContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct TelephonyContextProvider {
    let telephonyNetworkInfo: CTTelephonyNetworkInfoProtocol
    let carrier: CTCarrierProtocol?
    
//    init(telephonyNetworkInfo: CTTelephonyNetworkInfoProtocol? = nil, carrier: CTCarrierProtocol? = nil) {
//        switch (telephonyNetworkInfo, carrier) {
//        case let (telephonyNetworkInfo?, carrier?):
//            self.telephonyNetworkInfo = telephonyNetworkInfo
//            self.carrier = carrier
//        case (_, let carrier?):
//            self.telephonyNetworkInfo = CTTelephonyNetworkInfo()
//            self.carrier = carrier
//        case (let telephonyNetworkInfo?, _):
//            self.telephonyNetworkInfo = telephonyNetworkInfo
//            self.carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
//        case (_, _):
//            let telephonyNetworkInfo = CTTelephonyNetworkInfo()
//            self.telephonyNetworkInfo = telephonyNetworkInfo
//            self.carrier = telephonyNetworkInfo.subscriberCellularProvider
//        }
//        super.init()
//        self.name = "Add Telephony Info To Context"
//    }
}

extension TelephonyContextProvider: ContextProvider {
    
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
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        if let carrierName = carrier?.carrierName {
            logger.debug("Setting carrierName to: \(carrierName)")
            nextContext.carrierName = carrierName
        } else {
            logger.warn("Failed to capture carrier name – this is expected behaviour if you are running a simulator")
            nextContext.carrierName = nil
        }
        
        if let radio = currentRadio {
            logger.debug("Setting radio to: \(radio)")
            nextContext.radio = radio
        } else {
            logger.warn("Failed to capture radio")
            nextContext.radio = nil
        }
        
        return nextContext
    }
}
