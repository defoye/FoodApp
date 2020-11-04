//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class MainCoordinator {
    
    let viewControllers: [UIViewController]
    private let recipeSearchCoordinator: RecipeSearchCoordinator
    private let homeCoordinator: HomeCoordinator
    private let settingsCoordinator: ProfileSettingsCoordinator
    
    init() {
        self.recipeSearchCoordinator = RecipeSearchCoordinator()
        self.homeCoordinator = HomeCoordinator()
        self.settingsCoordinator = ProfileSettingsCoordinator()
        
        self.viewControllers = [
            homeCoordinator.presenter,
            recipeSearchCoordinator.presenter,
            settingsCoordinator.presenter
        ]
    }
    
	func start() {
		recipeSearchCoordinator.start()
        
        homeCoordinator.start()
        settingsCoordinator.start()
    }
}
