//
//  Logger.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public var logger = Logger()

public struct Logger {
    
    public typealias Printer = (String) -> Void
    
    public enum Level: Int, CustomStringConvertible {
        case debug
        case warn
        case error
        case none
        
        public var description: String {
            switch self {
            case .debug:
                return "Debug"
            case .warn:
                return "Warn"
            case .error:
                return "Error"
            case .none:
                return ""
            }
        }
    }
    
    public var threshold: Level
    
    public var printer: Printer
    
    public init(threshold: Level = .warn, printer: @escaping Printer = { print($0) }) {
        self.threshold = threshold
        self.printer = printer
    }
    
    @discardableResult public func log(message: String, level: Level) -> String? {
        guard level.rawValue >= threshold.rawValue else {
            return nil
        }
        
        let output = "[ROVER:\(level.description.uppercased())] \(message)"
        printer(output)
        return output
    }
    
    @discardableResult public func debug(_ message: String) -> String? {
        return log(message: message, level: .debug)
    }
    
    @discardableResult public func warn(_ message: String) -> String? {
        return log(message: message, level: .warn)
    }
    
    @discardableResult public func error(_ message: String) -> String? {
        return log(message: message, level: .error)
    }
    
    @discardableResult public func warnUnlessMainThread(_ message: String) -> String? {
        if !Thread.isMainThread {
            return logger.warn(message)
        }
        
        return nil
    }
    
    @discardableResult public func warnIfMainThread(_ message: String) -> String? {
        if Thread.isMainThread {
            return logger.warn(message)
        }
        
        return nil
    }
}

