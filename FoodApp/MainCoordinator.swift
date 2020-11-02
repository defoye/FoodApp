//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class MainCoordinator {
		
	func start() -> [UIViewController] {
        let recipeSearchCoordinator = RecipeSearchCoordinator()
		recipeSearchCoordinator.start()
        
        return [recipeSearchCoordinator.presenter]
	}
}
