//
//  ImageDownloadResult.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

enum ImageDownloadResult {
    case error(error: Error?)
    case success(image: UIImage)
}
