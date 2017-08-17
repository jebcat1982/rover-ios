//
//  BarcodeBlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

struct BarcodeBlockViewModel {
    var barcodeBlock: BarcodeBlock
}

extension BarcodeBlockViewModel {
    
    var barcodeImage: UIImage? {
        guard let data = barcodeBlock.barcodeText.data(using: String.Encoding.ascii) else {
            logger.error("Failed to encode barcode data from text: \(barcodeBlock.barcodeText)")
            return nil
        }
        
        let filter = CIFilter(name: barcodeFilterName)!
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        
        let scale = CGFloat(barcodeBlock.barcodeScale)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        
        guard let outputImage = filter.outputImage?.transformed(by: transform) else {
            logger.error("Failed to scale barcode image")
            return nil
        }
        
        let context = CIContext.init(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            logger.error("Failed to convert barcode image")
            return nil
        }
        
        return UIImage.init(cgImage: cgImage)
    }
    
    var barcodeAspectRatio: CGFloat {
        switch barcodeBlock.barcodeFormat {
        case .aztecCode:
            return CGFloat(1.0)
        case .code128:
            return CGFloat(2.26086956521739)
        case .pdf417:
            return CGFloat(2.25)
        case .qrCode:
            return CGFloat(1.0)
        }
    }
    
    var barcodeFilterName: String {
        switch barcodeBlock.barcodeFormat {
        case .aztecCode:
            return "CIAztecCodeGenerator"
        case .code128:
            return "CICode128BarcodeGenerator"
        case .pdf417:
            return "CIPDF417BarcodeGenerator"
        case .qrCode:
            return "CIQRCodeGenerator"
        }
    }
}

// MARK: BlockViewModel

extension BarcodeBlockViewModel: BlockViewModel {
    
    var cellReuseIdentifer: String {
        return BarcodeBlockView.defaultReuseIdentifier
    }
    
    var block: Block {
        return barcodeBlock
    }
    
    func intrinsicHeight(inBounds bounds: CGRect) -> CGFloat {
        return width(inBounds: bounds) / barcodeAspectRatio
    }
}

// MARK: BackgroundViewModel

extension BarcodeBlockViewModel: BackgroundViewModel {
    
    var background: Background {
        return barcodeBlock
    }
}

// MARK: BorderViewModel

extension BarcodeBlockViewModel: BorderViewModel {
    
    var border: Border {
        return barcodeBlock
    }
}
