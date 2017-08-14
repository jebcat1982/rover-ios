//
//  Container.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol Container: class, Resolver, Reducer, Dispatcher {
    var serialQueue: OperationQueue { get }
    var previousState: ContainerState { get set }
    var currentState: ContainerState { get set }
}

extension Container {
    
    func reduce(block: (ContainerState) -> ContainerState) {
        logger.warnIfMainThread("reduce should only be called from within the execute method of a ContainerOperation")
        previousState = currentState
        currentState = block(currentState)
    }
    
    func dispatch(_ operation: ContainerOperation, completionHandler: ((ContainerState, ContainerState) -> Void)?) {
        logger.warnUnlessMainThread("dispatch should only be called from the main thread")
        operation.reducer = self
        operation.resolver = self
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                completionHandler?(self.previousState, self.currentState)
            }
        }
        
        serialQueue.addOperation(operation)
    }
}
