//
//  HTTPTask.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol HTTPTask {
    
    func cancel()
    
    func resume()
}

// MARK: URLSessionUploadTask

extension URLSessionUploadTask: HTTPTask { }
