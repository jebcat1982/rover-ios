//
//  RowView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class RowView: UICollectionReusableView, BackgroundView {
    
    let backgroundImageView: UIImageView
    
    let backgroundImageDownloader = ImageDownloader()
    
    override init(frame: CGRect) {
        backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        clipsToBounds = true
        
        addSubview(backgroundImageView)
        
        backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with rowViewModel: RowViewModel, inFrame frame: CGRect) {
        configureBackground(with: rowViewModel, inFrame: frame)
    }
}
