//
//  WebViewBlockView.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation
import WebKit

class WebViewBlockView: BlockView {
    
    override var content: UIView? {
        return webView
    }
    
    let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    override func configure(with blockViewModel: BlockViewModel, inFrame frame: CGRect) {
        super.configure(with: blockViewModel, inFrame: frame)
        
        guard let webViewBlockViewModel = blockViewModel as? WebViewBlockViewModel else {
            webView.isHidden = true
            return
        }
        
        webView.isHidden = false
        webView.scrollView.isScrollEnabled = webViewBlockViewModel.isScrollEnabled
        webView.scrollView.bounces = webViewBlockViewModel.bounces
        
        let request = URLRequest(url: webViewBlockViewModel.url)
        webView.load(request)
    }
}
