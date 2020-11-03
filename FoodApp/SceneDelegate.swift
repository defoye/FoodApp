//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, GIDSignInDelegate {

	var window: UIWindow?

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
          // ...
          return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          // User is signed in
          // ...
        }
    }
    
    var tabBarController: UITabBarController
    var logonCoordinator: LogonCoordinator
	var mainCoordinator: MainCoordinator
    
    override init() {
        self.tabBarController = UITabBarController()
        self.logonCoordinator = LogonCoordinator()
        self.mainCoordinator = MainCoordinator()
        super.init()
        self.logonCoordinator.sceneDelegate = self
    }

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
        				
        self.window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        initVars()
        
        if !authenticate() {
            // Do something when logon fails
        }
	}
    
    func initVars() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func authenticate() -> Bool {
        self.logonCoordinator.start()
        
        window?.rootViewController = self.logonCoordinator.presenter
        
        return false
    }
    
    func logon() {
        self.logonCoordinator.finish()
        let mainCoordinator = MainCoordinator()
        self.mainCoordinator = mainCoordinator
            
        tabBarController.viewControllers = mainCoordinator.viewControllers
        
        window?.rootViewController = tabBarController
        
        mainCoordinator.start()
    }

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}


}

