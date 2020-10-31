//
//  SignInViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITableViewDelegate {
    enum Section: Hashable {
        case main
    }
    
    enum Row: Hashable {
        case logonLabel(_ model: LabelCell.Model)
        case username(_ model: TextFieldTableViewCell.Model)
        case password(_ model: TextFieldTableViewCell.Model)
        case logonButton(_ model: ButtonTableViewCell.Model)
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
    private weak var usernameCellDelegate: TextFieldTableViewCellDelegate?
    private weak var passwordCellDelegate: TextFieldTableViewCellDelegate?

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
        
        let logonLabelModel = LabelCell.Model()
        logonLabelModel.text = "Logon"
        logonLabelModel.font = UIFont.systemFont(ofSize: 30)
        
        let usernameModel = TextFieldTableViewCell.Model()
        usernameModel.labelText = "Username"
        usernameModel.insets = .init(top: 20, left: 20, bottom: -20, right: -20)
        usernameModel.textContentType = .username
        usernameModel.keyboardType = .emailAddress
        
        let passwordModel = TextFieldTableViewCell.Model()
        passwordModel.labelText = "Password"
        passwordModel.insets = .init(top: 20, left: 20, bottom: -20, right: -20)
        passwordModel.textContentType = .password
        passwordModel.isSecureTextEntry = true
        
        let logonButtonModel = ButtonTableViewCell.Model()
        logonButtonModel.title = "Log in"
        logonButtonModel.backgroundColor = .blue
        logonButtonModel.titleColor = .white
        logonButtonModel.insets = .init(top: 20, left: 20, bottom: -20, right: -20)
        
        snapshot.appendItems([
            .logonLabel(logonLabelModel),
            .username(usernameModel),
            .password(passwordModel),
            .logonButton(logonButtonModel)
        ])
        
        dataSource.apply(snapshot)
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableView)
        tableView.pin(to: view)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell? {
        switch row {
        
        case .logonLabel(let model):
            return tableView.configuredCell(LabelCell.self) { cell in
                cell.configure(model)
            }
        case .username:
            return tableView.configuredCell(TextFieldTableViewCell.self) { cell in
                let model = TextFieldTableViewCell.Model()
                model.labelText = "Username"
                model.insets = .init(top: 20, left: 20, bottom: -20, right: -20)
                model.textContentType = .username
                model.keyboardType = .emailAddress
                cell.configure(model)
                self.usernameCellDelegate = cell
            }
        case .password:
            return tableView.configuredCell(TextFieldTableViewCell.self) { cell in
                let model = TextFieldTableViewCell.Model()
                model.labelText = "Password"
                model.insets = .init(top: 20, left: 20, bottom: -20, right: -20)
                model.textContentType = .password
                model.isSecureTextEntry = true
                cell.configure(model, UIView())
                self.passwordCellDelegate = cell
            }
        case .logonButton:
            return tableView.configuredCell(ButtonTableViewCell.self) { cell in
                let model = ButtonTableViewCell.Model()
                model.title = "Log in"
                model.backgroundColor = .blue
                model.titleColor = .white
                model.insets = .init(top: 20, left: 20, bottom: -20, right: -20)
                cell.configure(model, delegate: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .logonLabel(_), .username, .password:
            break
        case .logonButton:
            break
        }
    }
}

extension SignInViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(_ id: String?) {
        coordinatorDelegate.logon()
    }
}
