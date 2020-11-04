//
//  LogonCoordinator.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol LogonCoordinatorDelegate {
    func coordinateToSignIn()
    func coordinateToSignUp()
    func logon()
}

class LogonCoordinator {
    
    let presenter: UINavigationController
    weak var sceneDelegate: SceneDelegate?
    
    init() {
        self.presenter = UINavigationController()
    }
    
    func start() {
        let viewController = LogonViewController(coordinatorDelegate: self)
        
        presenter.pushViewController(viewController, animated: false)
    }
    
    func finish() {
        presenter.popViewController(animated: false)
    }
}

extension LogonCoordinator: LogonCoordinatorDelegate {
    func coordinateToSignIn() {
        let viewController = SignInViewController(coordinatorDelegate: self)
        
        presenter.pushViewController(viewController, animated: true)
    }
    
    func coordinateToSignUp() {
        let viewController = SignUpViewController()
        
        presenter.pushViewController(viewController, animated: true)
    }
    
    func logon() {
        sceneDelegate?.logon()
    }
}
