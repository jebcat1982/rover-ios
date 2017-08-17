//
//  BackgroundViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol BackgroundViewModel {
    var background: Background { get }
    var backgroundColor: UIColor { get }
}

extension BackgroundViewModel {
    
    var backgroundColor: UIColor {
        return UIColor(color: background.backgroundColor)
    }
    
    var backgroundContentMode: UIViewContentMode {
        switch background.backgroundContentMode {
        case .fill:
            return .scaleAspectFill
        case .fit:
            return .scaleAspectFit
        case .original:
            return .center
        case .stretch:
            return .scaleToFill
        case .tile:
            return .center
        }
    }
    
    var backgroundImageHeight: CGFloat? {
        guard let backgroundImage = background.backgroundImage else {
            return nil
        }
        
        return CGFloat(backgroundImage.height)
    }
    
    var backgroundScale: CGFloat {
        switch background.backgroundScale {
        case .x1:
            return 1
        case .x2:
            return 2
        case .x3:
            return 3
        }
    }
    
    var backgroundImageWidth: CGFloat? {
        guard let backgroundImage = background.backgroundImage else {
            return nil
        }
        
        return CGFloat(backgroundImage.width)
    }
    
    var isTiledBackground: Bool {
        return background.backgroundContentMode == .tile
    }
    
    func backgroundImageConfiguration(inBounds bounds: CGRect) -> ImageConfiguration? {
        guard let backgroundImage = background.backgroundImage else {
            return nil
        }
        
        guard backgroundImage.isURLOptimizationEnabled else {
            return ImageConfiguration(backgroundImage.url, backgroundScale)
        }
        
        switch background.backgroundContentMode {
        case .fill:
            return fillConfiguration(inBounds: bounds)
        case .fit:
            return fitConfiguration(inBounds: bounds)
        case .original:
            return originalConfiguration(inBounds: bounds)
        case .stretch:
            return stretchConfiguration(inBounds: bounds)
        case .tile:
            return tileConfiguration(inBounds: bounds)
        }
    }
    
    func fillConfiguration(inBounds bounds: CGRect) -> ImageConfiguration? {
        let width = bounds.width * UIScreen.main.scale
        let height = bounds.height * UIScreen.main.scale
        
        let queryItems = [URLQueryItem(name: "fit", value: "min"),
                          URLQueryItem(name: "w", value: width.paramValue),
                          URLQueryItem(name: "h", value: height.paramValue)]
        
        return imageConfiguration(with: queryItems)
    }
    
    func fitConfiguration(inBounds bounds: CGRect) -> ImageConfiguration? {
        let width = bounds.width * UIScreen.main.scale
        let height = bounds.height * UIScreen.main.scale
        
        let queryItems = [URLQueryItem(name: "fit", value: "max"),
                          URLQueryItem(name: "w", value: width.paramValue),
                          URLQueryItem(name: "h", value: height.paramValue)]
        
        return imageConfiguration(with: queryItems)
    }
    
    func stretchConfiguration(inBounds bounds: CGRect) -> ImageConfiguration? {
        guard let backgroundImageWidth = self.backgroundImageWidth, let backgroundImageHeight = self.backgroundImageHeight else {
            return defaultImageConfiguration()
        }
        
        let width = min(bounds.width * UIScreen.main.scale, backgroundImageWidth)
        let height = min(bounds.height * UIScreen.main.scale, backgroundImageHeight)
        
        let queryItems = [URLQueryItem(name: "w", value: width.paramValue),
                          URLQueryItem(name: "h", value: height.paramValue)]
        
        return imageConfiguration(with: queryItems)
    }
    
    func originalConfiguration(inBounds bounds: CGRect) -> ImageConfiguration? {
        guard let backgroundImageWidth = self.backgroundImageWidth, let backgroundImageHeight = self.backgroundImageHeight else {
            return imageConfiguration(withScale: backgroundScale)
        }
        
        let width = min(bounds.width * backgroundScale, backgroundImageWidth)
        let height = min(bounds.height * backgroundScale, backgroundImageHeight)
        let x = (backgroundImageWidth - width) / 2
        let y = (backgroundImageHeight - height) / 2
        let rect = CGRect(x: x, y: y, width: width, height: height)
        return croppedConfiguration(for: rect)
    }
    
    func tileConfiguration(inBounds bounds: CGRect) -> ImageConfiguration? {
        guard let backgroundImageWidth = self.backgroundImageWidth, let backgroundImageHeight = self.backgroundImageHeight else {
            return imageConfiguration(withScale: backgroundScale)
        }
        
        let width = min(bounds.width * backgroundScale, backgroundImageWidth)
        let height = min(bounds.height * backgroundScale, backgroundImageHeight)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        return croppedConfiguration(for: rect)
    }
    
    func croppedConfiguration(for rect: CGRect) -> ImageConfiguration? {
        var queryItems = [URLQueryItem]()
        
        let value = [
            rect.origin.x.paramValue,
            rect.origin.y.paramValue,
            rect.width.paramValue,
            rect.height.paramValue
            ].joined(separator: ",")
        
        queryItems.append(URLQueryItem(name: "rect", value: value))
        
        var croppedScale = backgroundScale
        
        if UIScreen.main.scale < croppedScale {
            let width = rect.width / backgroundScale * UIScreen.main.scale
            let height = rect.height / backgroundScale * UIScreen.main.scale
            
            queryItems.append(contentsOf: [
                URLQueryItem(name: "w", value: width.paramValue),
                URLQueryItem(name: "h", value: height.paramValue)
                ])
            
            croppedScale = UIScreen.main.scale
        }
        
        return imageConfiguration(with: queryItems, andScale: croppedScale)
    }
    
    func defaultImageConfiguration() -> ImageConfiguration? {
        return imageConfiguration(with: nil, andScale: nil)
    }
    
    func imageConfiguration(withScale scale: CGFloat) -> ImageConfiguration? {
        return imageConfiguration(with: nil, andScale: scale)
    }
    
    func imageConfiguration(with queryItems: [URLQueryItem]) -> ImageConfiguration? {
        return imageConfiguration(with: queryItems, andScale: nil)
    }
    
    func imageConfiguration(with queryItems: [URLQueryItem]?, andScale scale: CGFloat?) -> ImageConfiguration? {
        guard let backgroundImage = background.backgroundImage else {
            return nil
        }
        
        let scale = scale ?? 1
        
        guard let queryItems = queryItems else {
            return (backgroundImage.url, scale)
        }
        
        guard var urlComponents = URLComponents(url: backgroundImage.url, resolvingAgainstBaseURL: false) else {
            logger.error("Invalid backgroundImageURL: \(backgroundImage.url)")
            return (backgroundImage.url, scale)
        }
        
        var optimizedQueryItems = urlComponents.queryItems ?? [URLQueryItem]()
        optimizedQueryItems += queryItems
        
        urlComponents.queryItems = optimizedQueryItems
        
        guard let optimizedURL = urlComponents.url else {
            logger.error("Invalid URLComponents: \(urlComponents)")
            return (backgroundImage.url, scale)
        }
        
        return (optimizedURL, scale)
    }
}
