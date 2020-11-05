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
import FirebaseStorage
import FirebaseDatabase

class ProfileSettingsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var image: UIImage? = nil
    var userId: String? = nil
    var profileImageUrl: URL? = nil
    var accountUserName: String? = nil
    weak var coordinatorDelegate: ProfileSettingsCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        imageStorage()
    }
    
    func setupUI() {
        profileImageView.makeRounded()
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.backgroundColor = .lightGray
        signOutButton.setTitle("SignOutButton", for: .normal)
        userName.text = Auth.auth().currentUser?.displayName
        userName.textColor = .blue
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imageStorage() {
        guard let imageSelected = self.image else { return print("profileImage is nil")}
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else { return }
        if let user = Auth.auth().currentUser?.uid, let imageUrl = Auth.auth().currentUser?.photoURL, let name = Auth.auth().currentUser?.displayName {
            print(user)
            userId = user
            profileImageUrl = imageUrl
            accountUserName = name
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://foodapp-5f684.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(userId ?? "")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            storageProfileRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    print(metaImageUrl)
                    let childUpdates = ["/users/": self.userId ?? ""]
                    self.profileImageUrl = URL(string: metaImageUrl)
                    Database.database().reference().child("users").child(self.userId ?? "").updateChildValues(childUpdates) { (error, ref) in
                        if error != nil {
                            print("Done")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        imageStorage()
        coordinatorDelegate?.logOut()
    }
        
}

extension ProfileSettingsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            profileImageView.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            profileImageView.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
