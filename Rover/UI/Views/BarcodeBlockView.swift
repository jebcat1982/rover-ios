//
//  BarcodeBlockView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class BarcodeBlockView: ImageBlockView {

    override func configure(with blockViewModel: BlockViewModel, inFrame frame: CGRect) {
        super.configure(with: blockViewModel, inFrame: frame)
        
        guard let barcodeBlockViewModel = blockViewModel as? BarcodeBlockViewModel else {
            return
        }
        
        imageView.image = barcodeBlockViewModel.barcodeImage
    }
}
