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
    func logon(_ logonCredentials: LogonCoordinator.LogonCredentials)
}

class LogonCoordinator {
    
    struct LogonCredentials {
        let username: String
        let password: String
    }
    
    weak var presenter: UINavigationController?
    weak var sceneDelegate: SceneDelegate?
    
    init(_ presenter: UINavigationController?, sceneDelegate: SceneDelegate?) {
        self.presenter = presenter
        self.sceneDelegate = sceneDelegate
    }
    
    func start() {
        let viewController = LogonViewController(coordinatorDelegate: self)
        
        presenter?.pushViewController(viewController, animated: false)
    }
}

extension LogonCoordinator: LogonCoordinatorDelegate {
    func coordinateToSignIn() {
        let viewController = SignInViewController(coordinatorDelegate: self)
        
        presenter?.pushViewController(viewController, animated: true)
    }
    
    func coordinateToSignUp() {
        let viewController = SignUpViewController()
        
        presenter?.pushViewController(viewController, animated: true)
    }
    
    func logon(_ logonCredentials: LogonCredentials) {
        sceneDelegate?.logon(logonCredentials)
    }
}
