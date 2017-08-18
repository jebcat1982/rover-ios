//
//  CaptureContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

class CaptureContextOperation: Operation {
    
    init() {
        super.init(operations: [
            AddApplicationInfoToContextOperation(),
            AddDeviceInfoToContextOperation(),
            AddSDKVersionToContextOperation(),
            AddLocaleToContextOperation(),
            AddLocationSettingsToContextOperation(),
            AddNotificationSettingsToContextOperation(),
            AddPushEnvironmentToContextOperation(),
            AddScreenSizeToContextOperation(),
            AddTelephonyInfoToContextOperation(),
            AddTimeZoneToContextOperation(),
            AddReachabilityInfoToContextOperation()
            ])
        self.name = "Capture Context"
    }
}
