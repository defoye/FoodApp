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
	func coordinateToRecipesList(_ passThroughData: SpoonacularAPI.ComplexSearch.ParamDict)
	func coordinateToRecipeDetail(urlString: String, item: RecipeListViewModel.Item)
}

class RecipeSearchCoordinator: RecipeSearchCoordinatorDelegate {
	
	var recipeSearchViewController: RecipeSearchViewController?
    let presenter = UINavigationController()
	
	func start() {
		let viewController = RecipeSearchViewController.instantiate("RecipeSearch")
		viewController.coordinatorDelegate = self
        viewController.tabBarItem = UITabBarItem(title: "Recipes", image: Constants.Images.cooking_book.image, selectedImage: nil)
		
		recipeSearchViewController = viewController
        presenter.viewControllers = [viewController]
	}
    
    func finish() {
        
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
        recipeSearchViewController?.reloadItems([.cuisinePicker])
	}
	
	func dishTypeSelected(_ dishType: SpoonacularAPI.DishType) {
		recipeSearchViewController?.dishTypeSelected = dishType
        recipeSearchViewController?.reloadItems([.dishPicker])
	}
	
	func coordinateToRecipesList(_ passThroughData: SpoonacularAPI.ComplexSearch.ParamDict) {
        let viewModel = RecipeListViewModel(passThroughData)
		let recipesViewController = RecipesListViewController(viewModel)
		
		presenter.pushViewController(recipesViewController, animated: true)
	}
	
	func coordinateToRecipeDetail(urlString: String, item: RecipeListViewModel.Item) {
        let vm = RecipeDetailViewModel(urlString, item)
		let vc = RecipeDetailViewController(vm)
		
		presenter.pushViewController(vc, animated: true)
	}
}
