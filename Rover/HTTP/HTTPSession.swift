//
//  HTTPSession.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public typealias UploadTaskHandler = (Data?, URLResponse?, Error?) -> Void

public protocol HTTPSession: class {
    
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping UploadTaskHandler) -> HTTPTask
}

// MARK: URLSession

//extension URLSession: HTTPSession {
//    
//    public func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping UploadTaskHandler) -> HTTPTask {
//        return (uploadTask(with: request, from: bodyData, completionHandler: completionHandler) as URLSessionUploadTask) as HTTPTask
//    }
//}

