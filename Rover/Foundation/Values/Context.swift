//
//  Context.swift
//  Rover
//
//  Created by Sean Rucker on 2017-09-01.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct Context: Codable {
    public var appBuild: String?
    public var appName: String?
    public var appNamespace: String?
    public var appVersion: String?
    public var carrierName: String?
    public var deviceManufacturer: String?
    public var deviceModel: String?
    public var isCellularEnabled: Bool?
    public var isLocationServicesEnabled: Bool?
    public var isWifiEnabled: Bool?
    public var locationAuthorization: String?
    public var localeLanguage: String?
    public var localeRegion: String?
    public var localeScript: String?
    public var notificationAuthorization: String?
    public var operatingSystemName: String?
    public var operatingSystemVersion: String?
    public var pushEnvironment: String?
    public var pushToken: String?
    public var radio: String?
    public var screenWidth: Int?
    public var screenHeight: Int?
    public var sdkVersion: String?
    public var timeZone: String?
    
    public init(appBuild: String? = nil, appName: String? = nil, appNamespace: String? = nil, appVersion: String? = nil, carrierName: String? = nil, deviceManufacturer: String? = nil, deviceModel: String? = nil, isCellularEnabled: Bool? = nil, isLocationServicesEnabled: Bool? = nil, isWifiEnabled: Bool? = nil, locationAuthorization: String? = nil, localeLanguage: String? = nil, localeRegion: String? = nil, localeScript: String? = nil, notificationAuthorization: String? = nil, operatingSystemName: String? = nil, operatingSystemVersion: String? = nil, pushEnvironment: String? = nil, pushToken: String? = nil, radio: String? = nil, screenWidth: Int? = nil, screenHeight: Int? = nil, sdkVersion: String? = nil, timeZone: String? = nil) {
        self.appBuild = appBuild
        self.appName = appName
        self.appNamespace = appNamespace
        self.appVersion = appVersion
        self.carrierName = carrierName
        self.deviceManufacturer = deviceManufacturer
        self.deviceModel = deviceModel
        self.isCellularEnabled = isCellularEnabled
        self.isLocationServicesEnabled = isLocationServicesEnabled
        self.isWifiEnabled = isWifiEnabled
        self.locationAuthorization = locationAuthorization
        self.localeLanguage = localeLanguage
        self.localeRegion = localeRegion
        self.localeScript = localeScript
        self.notificationAuthorization = notificationAuthorization
        self.operatingSystemName = operatingSystemName
        self.operatingSystemVersion = operatingSystemVersion
        self.pushEnvironment = pushEnvironment
        self.pushToken = pushToken
        self.radio = radio
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
        self.sdkVersion = sdkVersion
        self.timeZone = timeZone
    }
}

extension Context: Equatable {
    
    public static func ==(lhs: Context, rhs: Context) -> Bool {
        return lhs.appBuild == rhs.appBuild && lhs.appName == rhs.appName && lhs.appNamespace == rhs.appNamespace && lhs.appVersion == rhs.appVersion && lhs.carrierName == rhs.carrierName && lhs.deviceManufacturer == rhs.deviceManufacturer && lhs.deviceModel == rhs.deviceModel && lhs.isCellularEnabled == rhs.isCellularEnabled && lhs.isLocationServicesEnabled == rhs.isLocationServicesEnabled && lhs.isWifiEnabled == rhs.isWifiEnabled && lhs.locationAuthorization == rhs.locationAuthorization && lhs.localeLanguage == rhs.localeLanguage && lhs.localeRegion == rhs.localeRegion && lhs.localeScript == rhs.localeScript && lhs.notificationAuthorization == rhs.notificationAuthorization && lhs.operatingSystemName == rhs.operatingSystemName && lhs.operatingSystemVersion == rhs.operatingSystemVersion && lhs.pushEnvironment == rhs.pushEnvironment && lhs.pushToken == rhs.pushToken && lhs.radio == rhs.radio && lhs.screenWidth == rhs.screenWidth && lhs.screenHeight == rhs.screenHeight && lhs.sdkVersion == rhs.sdkVersion && lhs.timeZone == rhs.timeZone
    }
}
