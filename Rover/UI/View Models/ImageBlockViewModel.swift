//
//  ImageBlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

struct ImageBlockViewModel {
    var imageBlock: ImageBlock
}

extension ImageBlockViewModel {
    
    var imageSize: CGSize? {
        guard let image = imageBlock.image else {
            return nil
        }
        
        return CGSize(width: image.width, height: image.height)
    }
    
    func imageURL(inBounds bounds: CGRect) -> URL? {
        guard let image = imageBlock.image else {
            return nil
        }
        
        guard var urlComponents = URLComponents(url: image.url, resolvingAgainstBaseURL: false) else {
            logger.error("Invalid imageURL: \(image.url)")
            return image.url
        }
        
        let imageWidth = CGFloat(image.width)
        let imageHeight = CGFloat(image.height)
        let width = min(bounds.width * UIScreen.main.scale, imageWidth)
        let height = min(bounds.height * UIScreen.main.scale, imageHeight)
        
        let queryItems = [URLQueryItem(name: "w", value: width.paramValue),
                          URLQueryItem(name: "h", value: height.paramValue)]
        
        
        var optimizedQueryItems = urlComponents.queryItems ?? [URLQueryItem]()
        optimizedQueryItems += queryItems
        
        urlComponents.queryItems = optimizedQueryItems
        
        guard let optimizedURL = urlComponents.url else {
            logger.error("Invalid URLComponents: \(urlComponents)")
            return image.url
        }
        
        return optimizedURL
    }
}

// MARK: BlockViewModel

extension ImageBlockViewModel: BlockViewModel {
    
    var cellReuseIdentifer: String {
        return ImageBlockView.defaultReuseIdentifier
    }
    
    var block: Block {
        return imageBlock
    }
    
    func intrinsicHeight(inBounds bounds: CGRect) -> CGFloat {
        guard let image = imageBlock.image else {
            return 0
        }
        
        let aspectRatio = CGFloat(image.width) / CGFloat(image.height)
        return width(inBounds: bounds) / aspectRatio
    }
}

// MARK: BackgroundViewModel

extension ImageBlockViewModel: BackgroundViewModel {
    
    var background: Background {
        return imageBlock
    }
}

// MARK: BorderViewModel

extension ImageBlockViewModel: BorderViewModel {
    
    var border: Border {
        return imageBlock
    }
}
