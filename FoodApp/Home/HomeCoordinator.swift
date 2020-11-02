//
//  HomeCoordinator.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class HomeCoordinator {
    
    let presenter: UINavigationController
    
    init() {
        self.presenter = UINavigationController()
    }
    
    func start() {
        let homeViewController = HomeViewController()
        
        presenter.viewControllers = [homeViewController]
    }
}

