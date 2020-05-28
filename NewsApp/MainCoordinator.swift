//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class MainCoordinator {
	
	let tabBarController: UITabBarController
	var recipeSearchCoordinator: RecipeSearchCoordinator?
		
	init(_ tabBarController: UITabBarController) {
		self.tabBarController = tabBarController
		
		let topHeadlinesCategoriesViewController = TopHeadlinesCategoriesViewController.instantiate("TopHeadlinesCategories")
		
		let topHeadlinesCategoriesNavigationController = UINavigationController(rootViewController: topHeadlinesCategoriesViewController)
		
		let recipeSearchNavigationController = UINavigationController()
		
		tabBarController.viewControllers = [topHeadlinesCategoriesNavigationController, recipeSearchNavigationController]


		let coordinator = RecipeSearchCoordinator(recipeSearchNavigationController)
		self.recipeSearchCoordinator = coordinator
	}
	
	func start() {
		recipeSearchCoordinator?.start()
		
//		tabBarController.selectedIndex = 1
//		tabBarController.selectedIndex = 0
	}
}
