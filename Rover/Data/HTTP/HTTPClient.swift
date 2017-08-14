//
//  HTTPClient.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol HTTPClient {
    
    var session: HTTPSession { get }
    var baseURL: URL { get }
    var path: String { get }
}

extension HTTPClient {
    
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    func urlRequest(authHeaders: [String: String]) -> URLRequest {
        var r = URLRequest(url: url)
        r.setValue("gzip", forHTTPHeaderField: "accept-encoding")
        r.setValue("gzip", forHTTPHeaderField: "content-encoding")
        r.setValue("application/json", forHTTPHeaderField: "content-type")
        
        for (key, value) in authHeaders {
            r.addValue(value, forHTTPHeaderField: key)
        }
        
        return r
    }
    
    func httpResult<T>(from data: Data?, httpResponse: HTTPURLResponse, error: Error?) -> HTTPResult<T> {
        if let error = error {
            return .error(error: error, shouldRetry: true)
        }
        
        if httpResponse.statusCode >= 300 {
            let error = HTTPError.invalidStatusCode(statusCode: httpResponse.statusCode)
            
            let shouldRetry: Bool
            switch httpResponse.statusCode {
            case let n where n < 300:
                shouldRetry = false
            case let n where n < 400:
                shouldRetry = true
            case let n where n < 500:
                shouldRetry = false
            default:
                shouldRetry = true
            }
            
            return .error(error: error, shouldRetry: shouldRetry)
        }
        
        guard var data = data else {
            return .error(error: HTTPError.emptyResponseData, shouldRetry: false)
        }
        
        if data.isGzipped {
            do {
                try data = data.gunzipped()
            } catch {
                return .error(error: HTTPError.failedToUnzipResponseData, shouldRetry: false)
            }
        }
        
        let response: T
        let decoder = JSONDecoder()
        
        do {
            response = try decoder.decode(T.self, from: data)
        } catch {
            return .error(error: HTTPError.failedToDecodeResponseData, shouldRetry: false)
        }
        
        return .success(response: response)
    }
    
    func bodyData<T>(payload: T) -> Data? where T : Encodable {
        let data: Data
        let encoder = JSONEncoder()
        
        do {
            data = try encoder.encode(payload)
        } catch {
            logger.error("Failed to encode payload")
            return nil
        }
        
        return try? data.gzipped()
    }
    
    func uploadTask<T, U>(with payload: T, authHeaders: [String: String], completionHandler: ((HTTPResult<U>) -> Void)?) -> HTTPTask where T : Encodable {
        let urlRequest = self.urlRequest(authHeaders: authHeaders)
        let bodyData = self.bodyData(payload: payload)
        return session.uploadTask(with: urlRequest, from: bodyData, completionHandler: { (data, urlResponse, error) in
            let httpResponse = urlResponse as! HTTPURLResponse
            let httpResult: HTTPResult<U> = self.httpResult(from: data, httpResponse: httpResponse, error: error)
            completionHandler?(httpResult)
        })
    }
}
