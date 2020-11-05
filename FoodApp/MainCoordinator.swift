//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol MainCoordinatorDelegate: class {
    func logOut()
}

class MainCoordinator: MainCoordinatorDelegate {
    
    weak var sceneDelegate: SceneDelegate?
    let tabBarController: UITabBarController
    private let recipeSearchCoordinator: RecipeSearchCoordinator
    private let homeCoordinator: HomeCoordinator
    private let settingsCoordinator: ProfileSettingsCoordinator
    
    init() {
        self.recipeSearchCoordinator = RecipeSearchCoordinator()
        self.homeCoordinator = HomeCoordinator()
        self.settingsCoordinator = ProfileSettingsCoordinator()
        self.tabBarController = UITabBarController()

        self.tabBarController.viewControllers = [
            homeCoordinator.presenter,
            recipeSearchCoordinator.presenter,
            settingsCoordinator.presenter
        ]

        self.settingsCoordinator.coordinatorDelegate = self
    }
    
	func start() {
        tabBarController.selectedIndex = 0
		recipeSearchCoordinator.start()
        homeCoordinator.start()
        settingsCoordinator.start()
    }
    
    func finish() {
        recipeSearchCoordinator.finish()
        homeCoordinator.finish()
        settingsCoordinator.finish()
    }

    func logOut() {
        finish()
        sceneDelegate?.logOut()
    }
}
