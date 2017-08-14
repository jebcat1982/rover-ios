//
//  Reducer.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

protocol Reducer {
    
    func reduce(block: (ContainerState) -> ContainerState)
}
