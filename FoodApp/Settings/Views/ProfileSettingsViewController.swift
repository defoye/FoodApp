//
//  ProfileSettingsViewController.swift
//  FoodApp
//
//  Created by Ratna Kosanam on 11/4/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileSettingsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        signOutButton.setTitle("SignOutButton", for: .normal)
    }
    
    func logout() {
        
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        //            let vc = LogonViewController(coordinatorDelegate: nil)
        //
        //
        //            let viewController = LogonViewController(coordinatorDelegate: self)
        //
        //            presenter.pushViewController(viewController, animated: false)
        //
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let IntroVC = storyboard.instantiateViewController(withIdentifier: "IntroVC") as! introVC
        //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //            appDelegate.window?.rootViewController = IntroVC

        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }

    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        logout()
    }
        
}

extension ProfileSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
