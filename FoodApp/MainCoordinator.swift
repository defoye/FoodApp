//
//  MainCoordinator.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class SlideInMenuController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }
}

class MainCoordinator {
	
    let containerController: ContainerController
    private let slideInMenuController = SlideInMenuController()
    weak var navigationController: UINavigationController?
	var recipeSearchCoordinator: RecipeSearchCoordinator?
		
	init(_ navigationController: UINavigationController?) {
        self.containerController = ContainerController(navigationController, slideInController: slideInMenuController)
		self.navigationController = navigationController
						
        let coordinator = RecipeSearchCoordinator(navigationController, containerDelegate: containerController)
		self.recipeSearchCoordinator = coordinator
	}
	
	func start() {
		recipeSearchCoordinator?.start()
	}
}
