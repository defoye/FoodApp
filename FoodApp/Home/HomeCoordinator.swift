//
//  HomeCoordinator.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol HomeCoordinatorDelegate: class {
    func coordinateToRecipeDetail(item: FirebaseAPI.TopRecipesSearchResults.ResponseItem)
}

class HomeCoordinator {
    
    let presenter: UINavigationController
    
    init() {
        self.presenter = UINavigationController()
    }
    
    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinatorDelegate = self
        
        presenter.viewControllers = [homeViewController]
    }
    
    func finish() {
        
    }
}

extension HomeCoordinator: HomeCoordinatorDelegate {
    
    func coordinateToRecipeDetail(item: FirebaseAPI.TopRecipesSearchResults.ResponseItem) {
        let vm = RecipeDetailViewModel(item)
        let vc = RecipeDetailViewController(vm)
        
        presenter.pushViewController(vc, animated: true)
    }
}
