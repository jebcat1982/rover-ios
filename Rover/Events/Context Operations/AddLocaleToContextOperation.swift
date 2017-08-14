//
//  AddLocaleToContextOperation.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-14.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

class AddLocaleToContextOperation: ContainerOperation {
    let locale: LocaleProtocol
    
    init(locale: LocaleProtocol = Locale.current) {
        self.locale = locale
        super.init()
        self.name = "Add Locale To Context"
    }
    
    override func execute(reducer: Reducer, resolver: Resolver, completionHandler: @escaping () -> Void) {
        reducer.reduce { state in
            var nextContext = state.context
            
            nextContext.localeLanguage = locale.languageCode
            nextContext.localeRegion = locale.regionCode
            nextContext.localeScript = locale.scriptCode
            
            if nextContext.localeLanguage == nil {
                logger.warn("Failed to capture locale language")
            }
            
            if nextContext.localeRegion == nil {
                logger.warn("Failed to capture locale region")
            }
            
            var nextState = state
            nextState.context = nextContext
            return nextState
        }
        
        completionHandler()
    }
}
