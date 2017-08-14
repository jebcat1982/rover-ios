//
//  Resolver.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

protocol Resolver {
    
    var currentState: ContainerState { get }
    
    var previousState: ContainerState { get }
}
