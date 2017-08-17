//
//  ImageDownloader.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ImageDownloader {
    
    static var session = URLSession.shared
    
    private var dataTask: URLSessionDataTask?
    
    var isDownloading: Bool {
        return dataTask != nil
    }
    
    func cachedImage(for configuration: ImageConfiguration) -> UIImage? {
        return cachedImage(for: configuration.url, withScale: configuration.scale)
    }
    
    func cachedImage(for url: URL, withScale scale: CGFloat = 1.0) -> UIImage? {
        guard let urlCache = ImageDownloader.session.configuration.urlCache else {
            return nil
        }
        
        let request = URLRequest(url: url)
        let cachedResponse = urlCache.cachedResponse(for: request)
        
        guard let data = cachedResponse?.data else {
            return nil
        }
        
        return UIImage(data: data, scale: scale)
    }
    
    func downloadImage(from configuration: ImageConfiguration, completionHandler: @escaping (ImageDownloadResult) -> Void) {
        downloadImage(from: configuration.url, withScale: configuration.scale, completionHandler: completionHandler)
    }
    
    func downloadImage(from url: URL, withScale scale: CGFloat = 1.0, completionHandler: @escaping (ImageDownloadResult) -> Void) {
        let dataTask = ImageDownloader.session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                logger.error(error.localizedDescription)
                
                let result = ImageDownloadResult.error(error: error)
                completionHandler(result)
                return
            }
            
            guard let data = data else {
                let result = ImageDownloadResult.error(error: nil)
                completionHandler(result)
                return
            }
            
            guard let image = UIImage(data: data, scale: scale) else {
                return
            }
            
            let result = ImageDownloadResult.success(image: image)
            
            DispatchQueue.main.async {
                completionHandler(result)
            }
            
            self.dataTask = nil
        }
        
        dataTask.resume()
        self.dataTask = dataTask
    }
    
    func cancelDownload() {
        dataTask?.cancel()
    }
}
