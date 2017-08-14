//
//  Attributes.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

typealias AttributeName = String

protocol AttributeValue { }

extension String: AttributeValue { }

extension Int: AttributeValue { }

extension UInt: AttributeValue { }

extension Double: AttributeValue { }

extension Float: AttributeValue { }

extension Bool: AttributeValue { }

extension Date: AttributeValue { }

extension URL: AttributeValue { }

extension NSNull: AttributeValue { }

struct Attributes {
    var contents = [AttributeName: AttributeValue]()
}

extension Attributes {
    
    subscript(name: AttributeName) -> AttributeValue? {
        get {
            return contents[name]
        }
        
        set {
            contents[name] = newValue
        }
    }
}

extension Attributes: ExpressibleByDictionaryLiteral {
    
    init(dictionaryLiteral elements: (AttributeName, AttributeValue)...) {
        self.init()
        for (name, value) in elements {
            self[name] = value
        }
    }
}

extension Attributes: Codable {
    
    enum CodingKeys: String, CodingKey {
        case contents
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dictionary = try values.decode([String: Any].self, forKey: .contents)
        
        contents = dictionary.reduce([AttributeName: AttributeValue](), { (result, element) in
            var nextResult = result
            nextResult[element.key] = element.value as? AttributeValue
            return nextResult
        })
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let dictionary = contents.reduce([String: Any]()) { (result, element) in
            var nextResult = result
            nextResult[element.key] = element.value
            return nextResult
        }
        
        try container.encode(dictionary, forKey: .contents)
    }
}
