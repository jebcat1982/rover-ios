//
//  WebViewBlockViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

struct WebViewBlockViewModel {
    var webViewBlock: WebViewBlock
}

extension WebViewBlockViewModel {
    
    var bounces: Bool {
        return webViewBlock.isScrollingEnabled
    }
    
    var isScrollEnabled: Bool {
        return webViewBlock.isScrollingEnabled
    }
    
    var url: URL {
        return webViewBlock.url
    }
}

// MARK: BlockViewModel

extension WebViewBlockViewModel: BlockViewModel {
    
    var cellReuseIdentifer: String {
        return WebViewBlockView.defaultReuseIdentifier
    }
    
    var block: Block {
        return webViewBlock
    }
}

// MARK: BackgroundViewModel

extension WebViewBlockViewModel: BackgroundViewModel {
    
    var background: Background {
        return webViewBlock
    }
}

// MARK: BorderViewModel

extension WebViewBlockViewModel: BorderViewModel {
    
    var border: Border {
        return webViewBlock
    }
}
