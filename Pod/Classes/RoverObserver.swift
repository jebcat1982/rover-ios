//
//  RoverObserver.swift
//  RoverSDK
//
//  Created by Ata Namvari on 2016-01-25.
//  Copyright © 2016 Roverlabs Inc. All rights reserved.
//

import Foundation

/*
 Classes that conform to this protocol can be added as an observer to Rover and receive
 proximity and messaging callbacks.
 */

@objc
public protocol RoverObserver {
    
    /*
     Called when user enters a beacon region.
     
     - parameters:
        - config: The configuration of the beacon as it was set in the Rover Proximity App.
        - place: The place of the beacon if had been assigned.
     */
    @objc optional func didEnterBeaconRegion(config: BeaconConfiguration, place: Place?)
    
    /*
     Called when user exits a beacon region.
     
     - parameters:
        - config: The configuration of the beacon as it was set in the Rover Proximity App.
        - place: The place of the beacon if had been assigned.
     */
    @objc optional func didExitBeaconRegion(config: BeaconConfiguration, place: Place?)
    
    
    /*
     Called when user enters a geofence.
     
     - paramters: 
        - place: The place that was entered.
    */
    @objc optional func didEnterGeofence(place: Place) // 3 rules of real estate!!! :)
    
    /*
     Called when user exits a geofence.
     
     - parameters:
        - place: The place that was exited.
     */
    @objc optional func didExitGeofence(place: Place)
    
    /*
     Called after a `Message` has been received.
     
     - parameters:
        - message: The `Message` that was received.
     */
    @objc optional func didReceiveMessage(_ message: Message)
    
    /*
     Called to after a message has been received. Returning true will open the message content
     even if app is in the foreground. For default behaviour do not implement this method.
     
     - parameters:
        - message: The `Message` to be openned.
     */
    @objc optional func shouldOpenMessage(_ message: Message) -> Bool
    
    /*
     Called when any ExperienceViewController is about to load and render an Experience.
     Use this method to make any custom changes to the Experience.
     
     - parameters:
        - viewController: The `ExperienceViewController` instance that is about to load and render the experience.
        - experience: The `Experience` that is about to be loaded and rendered.
     */
    @objc optional func experienceViewController(_ viewController: ExperienceViewController, willLoadExperience experience: Experience)
}
