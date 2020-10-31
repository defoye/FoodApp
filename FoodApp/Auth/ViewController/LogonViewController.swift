//
//  LogonViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogonViewController: UIViewController, UITableViewDelegate {
    
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
        googleSignInModel.viewInsets = .init(top: 0, left: 20, bottom: -20, right: -20)
        
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
            return tableView.configuredCell(BlankTableViewCell.self) { cell in
                
                if #available(iOS 14.0, *) {
                    cell.configure(GIDSignInButton(frame: .zero, primaryAction: .init(handler: googleSignInTapped)), setupModel: setupModel, viewModel: viewModel)
                } else {
//                    return tableView.configuredCell(SignUpOptionCell.self) { cell in
//                        cell.configure(image: model.imageConstant?.image, description: model.description)
//                    }
                }
            }
        case .apple(let model), .facebook(let model), .email(let model):
            return tableView.configuredCell(SignUpOptionCell.self) { cell in
                cell.configure(image: model.imageConstant?.image, description: model.description)
            }
        case .signIn:
            return tableView.configuredCell(LabelCell.self) { cell in
                var model = LabelCell.Model()
                model.text = "Already have an account? Tap here to sign in."
                model.textInsets = .init(top: 20, left: 20, bottom: -20, right: -20)
                cell.configure(model)
            }
        }
    }
    
    @objc
    func googleSignInTapped(_ action: UIAction) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .logo(_):
            break
        case .apple(_), .google(_), .facebook(_), .email(_):
            coordinatorDelegate.coordinateToSignUp()
        case .signIn:
            coordinatorDelegate.coordinateToSignIn()
        }
    }
}
