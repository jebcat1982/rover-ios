//
//  LocaleContextProvider.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct LocaleContextProvider {
    let locale: LocaleProtocol
}

extension LocaleContextProvider: ContextProvider {
    
    func captureContext(_ context: Context) -> Context {
        var nextContext = context
        
        if let languageCode = locale.languageCode {
            logger.debug("Setting localeLanguage to: \(languageCode)")
            nextContext.localeLanguage = locale.languageCode
        } else {
            logger.warn("Failed to capture locale language")
            nextContext.localeLanguage = nil
        }
        
        if let regionCode = locale.regionCode {
            logger.debug("Setting localeRegion to: \(regionCode)")
            nextContext.localeRegion = locale.regionCode
        } else {
            logger.warn("Failed to capture locale region")
            nextContext.localeRegion = nil
        }
        
        if let scriptCode = locale.scriptCode {
            logger.debug("Setting localeScript to: \(scriptCode)")
            nextContext.localeScript = locale.scriptCode
        } else {
            nextContext.localeScript = nil
        }
        
        return nextContext
    }
}
