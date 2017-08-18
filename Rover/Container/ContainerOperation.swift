//
//  ContainerOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class ContainerOperation: Operation {
    
    let serialQueue: OperationQueue = {
        let q = OperationQueue()
        q.isSuspended = true
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    private var _isExecuting = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _isFinished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return _isExecuting
    }
    
    override var isFinished: Bool {
        return _isFinished
    }
    
    var finishOperation: BlockOperation!
    
    var delegate: ContainerOperationDelegate?
    var reducer: Reducer?
    var resolver: Resolver?
    
    init(operations: [ContainerOperation]? = nil) {
        super.init()
        
        finishOperation = BlockOperation {
            self.finish()
        }
        
        serialQueue.addOperation(finishOperation)
        
        if let operations = operations {
            addOperations(operations)
        }
    }
    
    func addOperations(_ operations: [ContainerOperation]) {
        operations.forEach(addOperation)
    }
    
    func addOperation(_ operation: ContainerOperation) {
        guard !finishOperation.isFinished && !finishOperation.isExecuting else {
            logger.error("Cannot add new operations after the operation has completed")
            return
        }
        
        operation.delegate = self
        finishOperation.addDependency(operation)
        serialQueue.addOperation(operation)
    }
    
    override func start() {
        super.start()
        
        if isCancelled {
            finish()
            return
        }
    }
    
    override func main() {
        if !isCancelled {
            _isExecuting = true
            delegate?.operationDidStart(self)
            execute()
        } else {
            finish()
        }
    }
    
    override func cancel() {
        serialQueue.cancelAllOperations()
        super.cancel()
        delegate?.operationDidCancel(self)
    }
    
    private func execute() {
        guard let reducer = reducer, let resolver = resolver else {
            logger.error("Container operation started with nil reducer and/or resolver")
            finish()
            return
        }
        
        execute(reducer: reducer, resolver: resolver) {
            for operation in self.serialQueue.operations {
                if let operation = operation as? ContainerOperation {
                    operation.reducer = reducer
                    operation.resolver = resolver
                }
            }
            
            self.serialQueue.isSuspended = false
        }
    }
    
    func finish() {
        _isExecuting = false
        _isFinished = true
        
        delegate?.operationDidFinish(self)
    }
    
    func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension ContainerOperation: ContainerOperationDelegate {
    
    func operationDidStart(_ operation: ContainerOperation) {
        delegate?.operationDidStart(operation)
    }
    
    func operationDidCancel(_ operation: ContainerOperation) {
        delegate?.operationDidCancel(operation)
    }
    
    func operationDidFinish(_ operation: ContainerOperation) {
        delegate?.operationDidFinish(operation)
    }
}
