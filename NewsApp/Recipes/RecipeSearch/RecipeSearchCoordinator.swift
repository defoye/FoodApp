//
//  RecipeSearchCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol RecipeSearchCoordinatorDelegate: class {
	func coordinateToCuisinePicker(_ type: RecipePickerType)
	func cuisineSelected(_ cuisine: SpoonacularAPI.Cuisine)
	func dishTypeSelected(_ dishType: SpoonacularAPI.DishType)
	func coordinateToRecipesList(_ passThroughData: [String: String])
	func coordinateToRecipeDetail(urlString: String, item: RecipesViewModel.Item)
}

class RecipeSearchCoordinator: RecipeSearchCoordinatorDelegate {
	
	let presenter: UINavigationController
	var recipeSearchViewController: RecipeSearchViewController?
	
	init(_ presenter: UINavigationController) {
		self.presenter = presenter
	}
	
	func start() {
		let viewController = RecipeSearchViewController.instantiate("RecipeSearch")
		viewController.coordinatorDelegate = self
		
		recipeSearchViewController = viewController
		
		presenter.pushViewController(viewController, animated: false)
	}
		
	func coordinateToCuisinePicker(_ type: RecipePickerType) {
		let cuisineViewController = CuisineViewController()
		cuisineViewController.initViewModel(type: type)
		let navigationController = UINavigationController(rootViewController: cuisineViewController)

		cuisineViewController.delegate = self
		presenter.present(navigationController, animated: true, completion: nil)
	}
	
	func cuisineSelected(_ cuisine: SpoonacularAPI.Cuisine) {
		recipeSearchViewController?.cuisineSelected = cuisine
		recipeSearchViewController?.reloadTableView()
	}
	
	func dishTypeSelected(_ dishType: SpoonacularAPI.DishType) {
		recipeSearchViewController?.dishTypeSelected = dishType
		recipeSearchViewController?.reloadTableView()
	}
	
	func coordinateToRecipesList(_ passThroughData: [String: String]) {
		let recipesViewController = RecipesViewController()
		let viewModel = RecipesViewModel(passThroughData)
		recipesViewController.initViewModel(viewModel)
		
		presenter.pushViewController(recipesViewController, animated: true)
	}
	
	func coordinateToRecipeDetail(urlString: String, item: RecipesViewModel.Item) {
		let vc = RecipeDetailViewController.instantiate("RecipeDetail")
		let vm = RecipeDetailViewModel(urlString, item)
		vc.initViewModel(vm)
		
		presenter.pushViewController(vc, animated: true)
	}
}
