//
//  Dispatcher.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

protocol Dispatcher {
    
    func dispatch(_ operation: ContainerOperation, completionHandler: ((ContainerState, ContainerState) -> Void)?)
}

extension Dispatcher {
    
    func dispatch(_ operation: ContainerOperation) {
        dispatch(operation, completionHandler: nil)
    }
}
