//
//  ScreenViewControllerDelegate.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public protocol ScreenViewControllerDelegate {
    func close()
    func goToScreen(withExperienceID experienceID: ID, screenID: ID)
}
