//
//  ExperienceViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

struct ExperienceViewModel {
    var experience: Experience
}

extension ExperienceViewModel {
    
    var screenViewModels: [ScreenViewModel] {
        return experience.screens.map { ScreenViewModel(screen: $0) }
    }
    
    var homeScreenViewModel: ScreenViewModel {
        return ScreenViewModel(screen: experience.homeScreen)
    }
    
    func screenViewModel(with id: ID) -> ScreenViewModel? {
        return screenViewModels.first { $0.screen.id == id }
    }
}
