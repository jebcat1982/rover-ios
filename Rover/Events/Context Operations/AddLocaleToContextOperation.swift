//
//  AddLocaleToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddLocaleToContextOperation: Operation {
    let locale: LocaleProtocol
    
    init(locale: LocaleProtocol = Locale.current) {
        self.locale = locale
        super.init()
        self.name = "Add Locale To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            if let languageCode = locale.languageCode {
                delegate?.debug("Setting localeLanguage to: \(languageCode)", operation: self)
                nextContext.localeLanguage = locale.languageCode
            } else {
                delegate?.warn("Failed to capture locale language", operation: self)
                nextContext.localeLanguage = nil
            }
            
            if let regionCode = locale.regionCode {
                delegate?.debug("Setting localeRegion to: \(regionCode)", operation: self)
                nextContext.localeRegion = locale.regionCode
            } else {
                delegate?.warn("Failed to capture locale region", operation: self)
                nextContext.localeRegion = nil
            }
            
            if let scriptCode = locale.scriptCode {
                delegate?.debug("Setting localeScript to: \(scriptCode)", operation: self)
                nextContext.localeScript = locale.scriptCode
            } else {
                nextContext.localeScript = nil
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
