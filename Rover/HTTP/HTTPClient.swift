//
//  HTTPClient.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-31.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public class HTTPClient {
    let endpoint: URL
    let session: HTTPSession
    let deviceIdentifier: DeviceIdentifier
    
    public var credentials: Credentials
    
    public init(accountToken: String, endpoint: URL = URL(string: "https://api.rover.io/")!, session: HTTPSession, deviceIdentifier: DeviceIdentifier) {
        self.credentials = Credentials(accountToken: accountToken)
        self.endpoint = endpoint
        self.session = session
        self.deviceIdentifier = deviceIdentifier
    }
    
    typealias AuthHeaders = [String: String]
    
    func authHeaders(credentials: Credentials) -> AuthHeaders {
        var authHeaders = AuthHeaders()
        authHeaders["x-rover-account-token"] = credentials.accountToken
        
        if let deviceIdentifier = deviceIdentifier.identify() {
            authHeaders["x-rover-device-identifier"] = deviceIdentifier
        } else {
            logger.error("Failed to obtain device identifier")
        }
        
        if let profileIdentifier = credentials.profileIdentifier {
            authHeaders["x-rover-profile-identifier"] = profileIdentifier
        }
        
        return authHeaders
    }
    
    func urlRequest(authHeaders: AuthHeaders) -> URLRequest {
        var r = URLRequest(url: endpoint)
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
    
    /**
     * Encodes and Gzips a payload.
     */
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
    
    struct GraphQLRoot<T>: Decodable where T: Decodable {
        let data: T
    }
    
    func uploadTask<T>(with query: T, credentials: Credentials? = nil, completionHandler: ((HTTPResult<T.Response>) -> Void)?) -> HTTPTask where T: HTTPQuery {
        return uploadTask(with: query, credentials: credentials, completionHandler: { (result: HTTPResult<GraphQLRoot<T.Response>>) in
            let flattenedResult: HTTPResult<T.Response>
            switch result {
            case let .error(error, shouldRetry):
                flattenedResult = .error(error: error, shouldRetry: shouldRetry)
            case let .success(root):
                flattenedResult = .success(response: root.data)
            }
            completionHandler?(flattenedResult)
        })
    }
    
    func uploadTask<T, U>(with payload: T, credentials: Credentials?, completionHandler: ((HTTPResult<U>) -> Void)?) -> HTTPTask where T : Encodable {
        let credentials = credentials ?? self.credentials
        let authHeaders = self.authHeaders(credentials: credentials)
        let urlRequest = self.urlRequest(authHeaders: authHeaders)
        let bodyData = self.bodyData(payload: payload)
        return session.uploadTask(with: urlRequest, from: bodyData, completionHandler: { (data, urlResponse, error) in
            let httpResponse = urlResponse as! HTTPURLResponse
            let httpResult: HTTPResult<U> = self.httpResult(from: data, httpResponse: httpResponse, error: error)
            completionHandler?(httpResult)
        })
    }
}

// MARK: DeviceIdentifier

public protocol DeviceIdentifier {
    func identify() -> String?
}

// MARK: Task Factories

extension HTTPClient {
    
    public func fetchExperienceTask(experienceID: ID, completionHandler: ((HTTPResult<Experience>) -> Void)?) -> HTTPTask {
        let query = FetchExperienceQuery(experienceID: experienceID)
        return uploadTask(with: query, completionHandler: { result in
            DispatchQueue.main.async {
                completionHandler?(result)
            }
        })
    }
    
    public func fetchStateTask(completionHandler: ((HTTPResult<State>) -> Void)?) -> HTTPTask {
        let query = FetchStateQuery()
        return uploadTask(with: query, completionHandler: { result in
            DispatchQueue.main.async {
                completionHandler?(result)
            }
        })
    }
    
    public func sendEventsTask(events: [Event], context: Context, credentials: Credentials?, completionHandler: ((HTTPResult<String>) -> Void)?) -> HTTPTask {
        let query = SendEventsQuery(events: events, context: context)
        return uploadTask(with: query, credentials: credentials) { result in
            DispatchQueue.main.async {
                completionHandler?(result)
            }
        }
    }
}
