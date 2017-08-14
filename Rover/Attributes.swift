//
//  Attributes.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public typealias AttributeName = String

public protocol AttributeValue { }

extension String: AttributeValue { }

extension Int: AttributeValue { }

extension UInt: AttributeValue { }

extension Double: AttributeValue { }

extension Float: AttributeValue { }

extension Bool: AttributeValue { }

extension Date: AttributeValue { }

extension URL: AttributeValue { }

extension NSNull: AttributeValue { }

public struct Attributes {
    var contents = [AttributeName: AttributeValue]()
    
    public init() { }
}

extension Attributes {
    
    subscript(name: AttributeName) -> AttributeValue? {
        get {
            return contents[name]
        }
        
        set {
            guard let newValue = newValue else {
                contents[name] = nil
                return
            }
            
            guard let attributeValue = Attributes.attributeValue(newValue) else {
                logger.error("Attribute values must of type String, Int, UInt, Double, Float, Bool, Date, URL or NSNull – got \(type(of: newValue))")
                return
            }
            
            contents[name] = attributeValue
        }
    }
}

extension Attributes: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (AttributeName, AttributeValue)...) {
        self.init()
        for (name, value) in elements {
            self[name] = value
        }
    }
}

extension Attributes: Codable {
    
    static func attributeValue(_ value: Any) -> AttributeValue? {
        guard let value = value as? AttributeValue else {
            return nil
        }
        
        switch value {
        case _ as String:
            fallthrough
        case _ as Int:
            fallthrough
        case _ as UInt:
            fallthrough
        case _ as Double:
            fallthrough
        case _ as Float:
            fallthrough
        case _ as Bool:
            fallthrough
        case _ as Date:
            fallthrough
        case _ as URL:
            fallthrough
        case _ as NSNull:
            return value
        default:
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case contents
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dictionary = try values.decode([String: Any].self, forKey: .contents)
        
        contents = dictionary.reduce([AttributeName: AttributeValue](), { (result, element) in
            var nextResult = result
            nextResult[element.key] = Attributes.attributeValue(element.value)
            return nextResult
        })
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let dictionary = contents.reduce([String: Any]()) { (result, element) in
            var nextResult = result
            nextResult[element.key] = Attributes.attributeValue(element.value)
            return nextResult
        }
        
        try container.encode(dictionary, forKey: .contents)
    }
}
