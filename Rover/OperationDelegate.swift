//
//  OperationDelegate.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol OperationDelegate: class {
    func operationDidStart(_ operation: Operation)
    func operationDidCancel(_ operation: Operation)
    func operationDidFinish(_ operation: Operation)
}
