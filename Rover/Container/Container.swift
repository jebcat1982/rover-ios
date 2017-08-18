//
//  Container.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol Container: class, ContainerOperationDelegate, Resolver, Reducer, Dispatcher {
    var serialQueue: OperationQueue { get }
    var previousState: ContainerState { get set }
    var currentState: ContainerState { get set }
}

extension Container {
    
    func calculateDepth(_ operation: ContainerOperation) -> Int {
        var depth = 0
        var child = operation
        while let parent = child.delegate as? ContainerOperation {
            depth += 1
            child = parent
        }
        return depth
    }
    
    func log(_ operation: ContainerOperation, message: String) {
        let depth = calculateDepth(operation)
        let padding = String(repeating: " ", count: depth * 4)
        logger.debug(padding + message)
    }
    
    func operationDidStart(_ operation: ContainerOperation) {
        let name = operation.name ?? "Unknown"
        log(operation, message: "\(name) {")
    }
    
    func operationDidCancel(_ operation: ContainerOperation) {
        log(operation, message: "cancelled")
    }
    
    func operationDidFinish(_ operation: ContainerOperation) {
        log(operation, message: "}")
    }
    
    func reduce(block: (ContainerState) -> ContainerState) {
        logger.warnIfMainThread("reduce should only be called from within the execute method of a ContainerOperation")
        previousState = currentState
        currentState = block(currentState)
    }
    
    func dispatch(_ operation: ContainerOperation, completionHandler: ((ContainerState, ContainerState) -> Void)?) {
        logger.warnUnlessMainThread("dispatch should only be called from the main thread")
        operation.delegate = self
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
