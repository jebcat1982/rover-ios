//
//  Locale.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

protocol LocaleProtocol {
    var languageCode: String? { get }
    var regionCode: String? { get }
    var scriptCode: String? { get }
}

extension Locale: LocaleProtocol { }
