//
//  ExperienceViewController.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

class ExperienceViewController: UINavigationController {
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    var experienceViewModel: ExperienceViewModel
    
    init(experienceViewModel: ExperienceViewModel) {
        self.experienceViewModel = experienceViewModel
        
        super.init(nibName: nil, bundle: nil)
        
        pushHomeScreen()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExperienceViewController {
    
    func pushHomeScreen() {
        let homeScreenViewController = ScreenViewController(screenViewModel: experienceViewModel.homeScreenViewModel)
        pushScreenViewController(homeScreenViewController, animated: false)
    }
    
    func pushScreenViewController(_ screenViewController: ScreenViewController, animated: Bool = true) {
        screenViewController.delegate = self
        pushViewController(screenViewController, animated: animated)
    }
}

// MARK: ScreenViewControllerDelegate

extension ExperienceViewController: ScreenViewControllerDelegate {
    
    func close() {
        self.dismiss(animated: true)
    }
    
    func goToScreen(withExperienceID experienceID: ID, screenID: ID) {
        guard let screenViewModel = experienceViewModel.screenViewModel(with: screenID) else {
            logger.warn("Failed to navigate to screen with ID: \(screenID.rawValue)")
            return
        }
        
        let screenViewController = ScreenViewController(screenViewModel: screenViewModel)
        pushScreenViewController(screenViewController)
    }
}
