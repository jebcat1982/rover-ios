//
//  BackgroundView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol BackgroundView: class {
    var backgroundImageView: UIImageView { get }
    var backgroundImageDownloader: ImageDownloader { get }
    var backgroundColor: UIColor? { get set }
}

extension BackgroundView {
    
    func configureBackground(with viewModel: BackgroundViewModel?, inFrame frame: CGRect) {
        backgroundColor = UIColor.clear
        backgroundImageView.backgroundColor = UIColor.clear
        backgroundImageView.image = nil
        backgroundImageDownloader.cancelDownload()
        
        guard let viewModel = viewModel else {
            return
        }
        
        backgroundColor = viewModel.backgroundColor
        backgroundImageView.contentMode = viewModel.backgroundContentMode
        
        guard let configuration = viewModel.backgroundImageConfiguration(inBounds: frame) else {
            return
        }
        
        if let image = backgroundImageDownloader.cachedImage(for: configuration) {
            if viewModel.isTiledBackground {
                backgroundImageView.backgroundColor = UIColor(patternImage: image)
            } else {
                backgroundImageView.image = image
            }
            return
        }
        
        backgroundImageView.alpha = 0.0
        backgroundImageDownloader.downloadImage(from: configuration) { result in
            switch result {
            case let .success(image):
                if viewModel.isTiledBackground {
                    self.backgroundImageView.backgroundColor = UIColor(patternImage: image)
                } else {
                    self.backgroundImageView.image = image
                }
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundImageView.alpha = 1.0
                })
            default:
                break
            }
        }
    }
}
