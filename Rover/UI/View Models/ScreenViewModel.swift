//
//  ScreenViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

struct ScreenViewModel {
    var screen: Screen
}

// MARK: BackgroundViewModel

extension ScreenViewModel: BackgroundViewModel {
    
    var background: Background {
        return screen
    }
}

// MARK: UICollectionViewDataSource

extension ScreenViewModel {
    
    var isStretchyHeaderEnabled: Bool {
        return screen.isStretchyHeaderEnabled
    }
    
    var rowViewModels: [RowViewModel] {
        return screen.rows.map { RowViewModel(row: $0) }
    }
    
    var numberOfSections: Int {
        return rowViewModels.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        guard rowViewModels.indices.contains(section) else {
            return 0
        }
        
        return rowViewModels[section].blockViewModels.count
    }
    
    func rowViewModel(at indexPath: IndexPath) -> RowViewModel? {
        guard rowViewModels.indices.contains(indexPath.section) else {
            return nil
        }
        
        return rowViewModels[indexPath.section]
    }
    
    func blockViewModel(at indexPath: IndexPath) -> BlockViewModel? {
        guard let rowViewModel = rowViewModel(at: indexPath) else {
            return nil
        }
        
        let blockViewModels = rowViewModel.blockViewModels
        
        guard blockViewModels.indices.contains(indexPath.row) else {
            return nil
        }
        
        return blockViewModels[indexPath.row]
    }
}

// MARK: Status bar

extension ScreenViewModel {
    
    var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle(statusBarStyle: screen.statusBarStyle)
    }
}

// MARK: Title

extension ScreenViewModel {
    
    var title: String {
        return screen.titleBarText
    }
}

// MARK: Navigation bar

extension ScreenViewModel {
    
    var navigationBarTitleColor: UIColor {
        if !screen.useDefaultTitleBarStyle {
            return UIColor(color: screen.titleBarTextColor)
        }
        
        if let appearanceColor = UINavigationBar.appearance().titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor {
            return appearanceColor
        }
        
        if let defaultColor = UINavigationBar().titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor {
            return defaultColor
        }
        
        return UIColor.black
    }
    
    var navigationBarBackgroundColor: UIColor {
        if !screen.useDefaultTitleBarStyle {
            return UIColor(color: screen.titleBarBackgroundColor)
        }
        
        if let appearanceColor = UINavigationBar.appearance().barTintColor {
            return appearanceColor
        }
        
        if let defaultColor = UINavigationBar().barTintColor {
            return defaultColor
        }
        
        return UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
    }
    
    var navigationBarItemColor: UIColor {
        if !screen.useDefaultTitleBarStyle {
            return UIColor(color: screen.titleBarButtonColor)
        }
        
        if let appearanceColor = UINavigationBar.appearance().tintColor {
            return appearanceColor
        }
        
        if let defaultColor = UINavigationBar().tintColor {
            return defaultColor
        }
        
        return UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
    }
    
    func applyNavigationBarTitleColor(toTitleTextAttributes currentAttributes: [NSAttributedStringKey: Any]?) -> [NSAttributedStringKey: Any] {
        var nextAttributes = currentAttributes ?? [NSAttributedStringKey: Any]()
        nextAttributes[NSAttributedStringKey.foregroundColor] = navigationBarTitleColor
        return nextAttributes
    }
}

// MARK: Navigation item

extension ScreenViewModel {
    
    var hasCloseButton: Bool {
        switch screen.titleBarButtons {
        case .back:
            return false
        default:
            return true
        }
    }
    
    var hidesBackButton: Bool {
        switch screen.titleBarButtons {
        case .close:
            return true
        default:
            return false
        }
    }
}
