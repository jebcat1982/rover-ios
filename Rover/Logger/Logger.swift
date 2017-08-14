//
//  Logger.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-11.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

var logger = Logger()

struct Logger {
    typealias Printer = (String) -> Void
    
    enum Level: Int, CustomStringConvertible {
        case debug
        case warn
        case error
        case none
        
        var description: String {
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
    
    var threshold: Level
    
    var printer: Printer
    
    init(threshold: Level = .warn, printer: @escaping Printer = { print($0) }) {
        self.threshold = threshold
        self.printer = printer
    }
    
    @discardableResult func log(message: String, level: Level) -> String? {
        guard level.rawValue >= threshold.rawValue else {
            return nil
        }
        
        let output = "[ROVER:\(level.description.uppercased())] \(message)"
        printer(output)
        return output
    }
    
    @discardableResult func debug(_ message: String) -> String? {
        return log(message: message, level: .debug)
    }
    
    @discardableResult func warn(_ message: String) -> String? {
        return log(message: message, level: .warn)
    }
    
    @discardableResult func error(_ message: String) -> String? {
        return log(message: message, level: .error)
    }
    
    @discardableResult func warnUnlessMainThread(_ message: String) -> String? {
        if !Thread.isMainThread {
            return logger.warn(message)
        }
        
        return nil
    }
    
    @discardableResult func warnIfMainThread(_ message: String) -> String? {
        if Thread.isMainThread {
            return logger.warn(message)
        }
        
        return nil
    }
}
