//
//  Attributes.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

typealias AttributeName = String

struct AttributeValue: Codable {
    let rawValue: Any
    
    enum CodingKeys: String, CodingKey {
        case rawValue
    }
    
    init?(rawValue: Any?) {
        guard let rawValue = rawValue else {
            return nil
        }
        
        switch rawValue {
        case is String, is Int, is UInt, is Double, is Float, is Bool, is Date, is URL:
            self.rawValue = rawValue
        default:
            logger.error("Attribute values must of type String, Int, UInt, Double, Float, Bool, Date or URL – got \(type(of: rawValue))")
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let string = try? container.decode(String.self, forKey: .rawValue) {
            self.rawValue = string
            return
        }
        
        if let int = try? container.decode(Int.self, forKey: .rawValue) {
            self.rawValue = int
            return
        }
        
        if let uint = try? container.decode(UInt.self, forKey: .rawValue) {
            self.rawValue = uint
            return
        }
        
        if let double = try? container.decode(Double.self, forKey: .rawValue) {
            self.rawValue = double
            return
        }
        
        if let float = try? container.decode(Float.self, forKey: .rawValue) {
            self.rawValue = float
            return
        }
        
        if let bool = try? container.decode(Bool.self, forKey: .rawValue) {
            self.rawValue = bool
            return
        }
        
        if let date = try? container.decode(Date.self, forKey: .rawValue) {
            self.rawValue = date
            return
        }
        
        if let url = try? container.decode(URL.self, forKey: .rawValue) {
            self.rawValue = url
            return
        }
        
        throw DecodingError.dataCorruptedError(forKey: .rawValue, in: container, debugDescription: "Attribute values must of type String, Int, UInt, Double, Float, Bool, Date or URL")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let string = rawValue as? String {
            try container.encode(string, forKey: .rawValue)
        }
        
        if let int = rawValue as? Int {
            try container.encode(int, forKey: .rawValue)
        }
        
        if let uint = rawValue as? UInt {
            try container.encode(uint, forKey: .rawValue)
        }
        
        if let double = rawValue as? Double {
            try container.encode(double, forKey: .rawValue)
        }
        
        if let float = rawValue as? Float {
            try container.encode(float, forKey: .rawValue)
        }
        
        if let bool = rawValue as? Bool {
            try container.encode(bool, forKey: .rawValue)
        }
        
        if let date = rawValue as? Date {
            try container.encode(date, forKey: .rawValue)
        }
        
        if let url = rawValue as? URL {
            try container.encode(url, forKey: .rawValue)
        }
    }
}

extension AttributeValue: Equatable {
    
    static func == (lhs: AttributeValue, rhs: AttributeValue) -> Bool {
        switch (lhs.rawValue, rhs.rawValue) {
        case (let lhs as String, let rhs as String):
            return lhs == rhs
        case (let lhs as Int, let rhs as Int):
            return lhs == rhs
        case (let lhs as UInt, let rhs as UInt):
            return lhs == rhs
        case (let lhs as Double, let rhs as Double):
            return lhs == rhs
        case (let lhs as Float, let rhs as Float):
            return lhs == rhs
        case (let lhs as Bool, let rhs as Bool):
            return lhs == rhs
        case (let lhs as Date, let rhs as Date):
            return lhs == rhs
        case (let lhs as URL, let rhs as URL):
            return lhs == rhs
        default:
            return false
        }
    }
}

public struct Attributes: Codable {
    var contents = [AttributeName: AttributeValue]()
    
    public init() { }
}

extension Attributes {
    
    subscript(name: String) -> Any? {
        get {
            return contents[name]
        }
        
        set {
            contents[name] = AttributeValue(rawValue: newValue)
        }
    }
}

extension Attributes: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        self.init()
        for (name, value) in elements {
            self[name] = value
        }
    }
}

extension Attributes: Equatable {
    
    public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
        return lhs.contents == rhs.contents
    }
}
