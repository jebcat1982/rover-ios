//
//  Context.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct Context: Codable {
    var appName: String?
    var appVersion: String?
    var appBuild: String?
    var appNamespace: String?
    
    var deviceManufacturer: String?
    var deviceModel: String?
    
    var operatingSystemVersion: String?
    var operatingSystemName: String?
    
    var sdkVersion: String?
    
    var localeLanguage: String?
    var localeRegion: String?
    var localeScript: String?
    
    var screenWidth: Int?
    var screenHeight: Int?
    
    var carrierName: String?
    var radio: String?
    
    var timeZone: String?
    
    var isWifiEnabled: Bool?
    var isCellularEnabled: Bool?
    
    var pushToken: String?
    var pushEnvironment: String?
    
    var notificationAuthorization: String?
    
    var locationAuthorization: String?
    var isLocationServicesEnabled: Bool?
}
