//
//  ContainerOperationDelegate.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol ContainerOperationDelegate: class {
    func operationDidStart(_ operation: ContainerOperation)
    func operationDidCancel(_ operation: ContainerOperation)
    func operationDidFinish(_ operation: ContainerOperation)
}
