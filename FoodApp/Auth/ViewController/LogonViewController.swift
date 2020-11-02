//
//  LogonViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class LogonViewController: UIViewController, UITableViewDelegate, FUIAuthDelegate {
    
    enum Section: Hashable {
        case main
    }
    
    enum Row: Hashable {
        case logo(_ image: FoodAppImageConstants)
        
        case apple(_ model: SignUpOptionModel)
        case google(_ setupModel: BlankTableViewCell.SetupModel, _ viewModel: BlankTableViewCell.ViewModel)
        case facebook(_ model: SignUpOptionModel)
        case email(_ model: SignUpOptionModel)
        
        case signIn
    }
    
    struct SignUpOptionModel: Hashable {
        let imageConstant: FoodAppImageConstants?
        let description: String
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Row> = {
        UITableViewDiffableDataSource<Section, Row>(tableView: self.tableView) { [weak self] (tableView, indexPath, row) -> UITableViewCell? in
            self?.cellProvider(tableView, indexPath: indexPath, row: row)
        }
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 100, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private let coordinatorDelegate: LogonCoordinatorDelegate
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    init(coordinatorDelegate: LogonCoordinatorDelegate) {
        self.coordinatorDelegate = coordinatorDelegate
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        addSubviewsAndConstraints()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    private func setupDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        
        let googleSignInModel = BlankTableViewCell.ViewModel()
        googleSignInModel.viewInsets = .init(top: 0, left: 70, bottom: -20, right: -70)
        
        snapshot.appendItems([
            .logo(.apple_logo),
            .apple(SignUpOptionModel(imageConstant: .apple_logo, description: "Sign up with Apple")),
            .google(BlankTableViewCell.SetupModel(), googleSignInModel),
            .facebook(SignUpOptionModel(imageConstant: .facebook_logo, description: "Sign up with Facebook")),
            .email(SignUpOptionModel(imageConstant: .email_logo, description: "Sign up with Email")),
            .signIn
        ])
        
        dataSource.apply(snapshot)
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableView)
        tableView.pin(to: view)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell? {
        
        switch row {
        case .logo(let image):
            return tableView.configuredCell(SignUpLogoCell.self) { cell in
                cell.configure(image: image.image)
            }
        case .google(let setupModel, let viewModel):
            if #available(iOS 14.0, *) {
                return tableView.configuredCell(BlankTableViewCell.self) { cell in
                    cell.configure(GIDSignInButton(frame: .zero, primaryAction: .init(handler: googleSignInTapped)), setupModel: setupModel, viewModel: viewModel)
                }
            } else {
                return nil
            }
        case .apple(let model), .facebook(let model), .email(let model):
            return tableView.configuredCell(SignUpOptionCell.self) { cell in
                cell.configure(image: model.imageConstant?.image, description: model.description)
            }
        case .signIn:
            return tableView.configuredCell(LabelCell.self) { cell in
                let model = LabelCell.Model()
                model.text = "Already have an account? Tap here to sign in."
                model.textInsets = .init(top: 20, left: 20, bottom: -20, right: -20)
                cell.configure(model)
            }
        }
    }
    
    @objc
    func googleSignInTapped(_ action: UIAction) {
        
    }
    
    @objc
    func appleSignInTapped() {
        performSignin()
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .logo(_):
            break
        case .apple(_):
            appleSignInTapped()
        case .google(_), .facebook(_), .email(_):
            coordinatorDelegate.coordinateToSignUp()
        case .signIn:
            coordinatorDelegate.coordinateToSignIn()
        }
    }
}

extension LogonViewController {
    
    func performSignin() {
        let request = createAppleIDRequest()
        let authrozationController = ASAuthorizationController(authorizationRequests: [request])
        authrozationController.delegate = self
        authrozationController.presentationContextProvider = self
        authrozationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let applePro = ASAuthorizationAppleIDProvider()
        let request = applePro.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nounce = randomNonceString()
        request.nonce = sha256(nounce)
        currentNonce = nounce
        return request
        
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result

    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("Nice! you logged in \(user.uid)")
        }
    }

}

extension LogonViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nounce = currentNonce else {
                fatalError("Invalid state")
            }
            guard let appleIdToken = appleIDCredential.identityToken else {
                fatalError("unable to fetch identity token")
            }
            
            guard let idTokenString = String(data: appleIdToken, encoding: .utf8) else {
                fatalError("askjdbas")
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nounce)
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    print("ypu have signed in as \(user.uid)")
                }
            }

        }
    }
}

extension LogonViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    

}
