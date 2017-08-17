//
//  BlockView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class BlockView: UICollectionViewCell, BackgroundView {
    var delegate: BlockViewDelegate?
    
    var content: UIView? {
        return nil
    }
    
    var backgroundImageView: UIImageView {
        return backgroundView as! UIImageView
    }
    
    let backgroundImageDownloader = ImageDownloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView()
        clipsToBounds = true
        
        if let content = content {
            content.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(content)
        }
        
        addTapGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    func configure(with blockViewModel: BlockViewModel, inFrame frame: CGRect) {
        configureOpacity(with: blockViewModel)
        configureConstraints(with: blockViewModel)
        configureBackground(with: blockViewModel as? BackgroundViewModel, inFrame: frame)
        configureBorder(with: blockViewModel as? BorderViewModel, inFrame: frame)
    }
    
    func configureOpacity(with blockViewModel: BlockViewModel) {
        layer.opacity = blockViewModel.opacity
    }
    
    func configureConstraints(with blockViewModel: BlockViewModel) {
        guard let content = self.content else {
            return
        }
        
        let insets = blockViewModel.insets
        
        content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: insets.bottom).isActive = true
        content.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: insets.left).isActive = true
        content.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: insets.right).isActive = true
        content.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top).isActive = true
    }
    
    func configureBorder(with viewModel: BorderViewModel?, inFrame frame: CGRect) {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 0
        
        guard let viewModel = viewModel else {
            return
        }
        
        layer.borderColor = viewModel.borderColor
        layer.borderWidth = viewModel.borderWidth
        layer.cornerRadius = viewModel.cornerRadius(inFrame: frame)
    }
    
    // MARK: Tap
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        switch tapGestureRecognizer.state {
        case .ended:
            delegate?.blockViewDidTap(self)
        default:
            break;
        }
    }
}
