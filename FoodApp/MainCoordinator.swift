//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class MainCoordinator {
	
    weak var navigationController: UINavigationController?
	var recipeSearchCoordinator: RecipeSearchCoordinator?
		
	init(_ navigationController: UINavigationController?) {
		self.navigationController = navigationController
						
		let coordinator = RecipeSearchCoordinator(navigationController)
		self.recipeSearchCoordinator = coordinator
	}
	
	func start() {
		recipeSearchCoordinator?.start()
	}
}
