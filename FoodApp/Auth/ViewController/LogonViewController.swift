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
import FBSDKLoginKit
import Firebase

class LogonViewController: UIViewController, FUIAuthDelegate {
    
    enum Section: Hashable {
        case main
    }
    
    enum Row: Hashable {
        case logo(_ image: Constants.Images)
        
        case apple(_ viewModel: BlankTableViewCell.ViewModel)
        case google(_ setupModel: BlankTableViewCell.SetupModel, _ viewModel: BlankTableViewCell.ViewModel)
        case facebook( _ viewModel: BlankTableViewCell.ViewModel)
        case email(_ model: SignUpOptionModel)
        
        case signUp
    }
    
    struct SignUpOptionModel: Hashable {
        let imageConstant: Constants.Images?
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
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
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
        googleSignInModel.viewInsets = .init(top: 0, left: 67, bottom: -20, right: -67)
        
        let appleSignInModel = BlankTableViewCell.ViewModel()
        appleSignInModel.viewInsets = .init(top: 0, left: 70, bottom: -20, right: -70)
        
        let facebookSignInModel = BlankTableViewCell.ViewModel()
        facebookSignInModel.viewInsets = .init(top: 0, left: 70, bottom: -20, right: -70)
        
        snapshot.appendItems([
            .logo(.apple_logo),
            .apple(appleSignInModel),
            .google(BlankTableViewCell.SetupModel(), googleSignInModel),
            .facebook(facebookSignInModel),
            .email(SignUpOptionModel(imageConstant: .email_logo, description: "Sign in with Email")),
            .signUp
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
                    cell.configure(GIDSignInButton(frame: .zero, primaryAction: .init(handler: { action in

                    })), setupModel: setupModel, viewModel: viewModel)
                }
            } else {
                return nil
            }
        case .facebook(let viewModel):
            return tableView.configuredCell(BlankTableViewCell.self) { cell in
                let loginButton = FBLoginButton()
                loginButton.center = view.center
                loginButton.delegate = self
                loginButton.permissions = ["public_profile", "email"]
                cell.configure(loginButton, viewModel: viewModel)
            }

        case .apple(let viewModel):
            return tableView.configuredCell(BlankTableViewCell.self) { cell in
                let authorizationButton = ASAuthorizationAppleIDButton()
                authorizationButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
                cell.configure(authorizationButton, viewModel: viewModel)
            }
        case .email(let model):
            return tableView.configuredCell(SignUpOptionCell.self) { cell in
                cell.configure(image: model.imageConstant?.image, description: model.description)
            }
        case .signUp:
            return tableView.configuredCell(LabelCell.self) { cell in
                let model = LabelCell.Model()
                model.text = "Don't have an account? Tap here to sign up."
                model.textInsets = .init(top: 20, left: 20, bottom: -20, right: -20)
                cell.configure(model)
            }
        }
    }
    
    @objc
    func appleSignInTapped() {
        performSignin()
    }
}

// MARK:- UITableViewDelegate

extension LogonViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .logo(_):
            break
        case .apple(_):
            break
        case .facebook(_):
            break
        case .google(_):
            break
        case .email(_):
            coordinatorDelegate.coordinateToSignIn()
        case .signUp:
            coordinatorDelegate.coordinateToSignUp()
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
        let nounce = String.randomNonceString()
        request.nonce = nounce.sha256()
        currentNonce = nounce
        return request
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.sha256()

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            coordinatorDelegate.logon()
        }
    }

}

// MARK:- Appla Sign in

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
                    self.coordinatorDelegate.logon()
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

// MARK: - Facebook Sign in

extension LogonViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print("Facebook login with error: \(error?.localizedDescription)")
            return
        }
        guard let token = AccessToken.current?.tokenString else { return }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    print("// The user is a multi-factor user. Second factor challenge is required.")
                }
            } else {
                print("Suucess login with Facebook")
                self.coordinatorDelegate.logon()
            }
       }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}

// MARK: - Google Sign in

extension LogonViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("LogonViewController::sign - \(error.localizedDescription)")
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          // User is signed in
            print("User is signed in via google")
          // ...
            self.coordinatorDelegate.logon()
        }
    }    
}
