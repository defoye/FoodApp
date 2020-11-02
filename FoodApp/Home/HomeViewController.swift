//
//  HomeViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        self.title = "Home"
        
        FirebaseDataManager.shared.fetchTopRecipes(numberOfResults: 20) { models in
            
        }
    }
}
