//
//  ProfileSettingsCoordinator.swift
//  FoodApp
//
//  Created by Ratna Kosanam on 11/4/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation
import UIKit

class ProfileSettingsCoordinator {
    
    let presenter: UINavigationController
    
    var profileSettingsVC: ProfileSettingsViewController?

    init() {
        self.presenter = UINavigationController()
    }
    
    func start() {
        let viewController = ProfileSettingsViewController.instantiate("Profile&Settings")
        viewController.tabBarItem = UITabBarItem(title: "Profile & Settings", image: Constants.Images.info.image, selectedImage: nil)
        
        profileSettingsVC = viewController
        presenter.viewControllers = [viewController]
    }
}
