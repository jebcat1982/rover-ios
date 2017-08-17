//
//  ImageBlockView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ImageBlockView: BlockView {
    
    override var content: UIView? {
        return imageView
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var imageDownloader = ImageDownloader()
    
    override func configure(with blockViewModel: BlockViewModel, inFrame frame: CGRect) {
        super.configure(with: blockViewModel, inFrame: frame)
        
        imageView.image = nil
        imageDownloader.cancelDownload()
        
        guard let imageBlockViewModel = blockViewModel as? ImageBlockViewModel, let imageURL = imageBlockViewModel.imageURL(inBounds: frame) else {
            return
        }
        
        if let image = imageDownloader.cachedImage(for: imageURL) {
            imageView.image = image
            return
        }
        
        imageView.alpha = 0.0
        imageDownloader.downloadImage(from: imageURL) { result in
            switch result {
            case let .success(image):
                self.imageView.image = image
                
                UIView.animate(withDuration: 0.25, animations: { 
                    self.imageView.alpha = 1.0
                })
            default:
                break
            }
        }
    }
}
