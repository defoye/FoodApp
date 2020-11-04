//
//  ProfileSettingsCoordinator.swift
//  FoodApp
//
//  Created by Ratna Kosanam on 11/4/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileSettingsCoordinatorDelegate: class {
    func logOut()
}

class ProfileSettingsCoordinator: ProfileSettingsCoordinatorDelegate {
    
    let presenter: UINavigationController
    weak var coordinatorDelegate: MainCoordinatorDelegate?
    
    var profileSettingsVC: ProfileSettingsViewController?

    init() {
        self.presenter = UINavigationController()
    }
    
    func start() {
        let viewController = ProfileSettingsViewController.instantiate("Profile&Settings")
        viewController.tabBarItem = UITabBarItem(title: "Profile & Settings", image: Constants.Images.info.image, selectedImage: nil)
        viewController.coordinatorDelegate = self
        
        profileSettingsVC = viewController
        presenter.viewControllers = [viewController]
    }
    
    func finish() {
        
    }
    
    func logOut() {
        coordinatorDelegate?.logOut()
    }
}
