//
//  LogonViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class LogonViewController: UIViewController, UITableViewDelegate {
    
    enum Section: Hashable {
        case main
    }
    
    enum Row: Hashable {
        case logo(_ image: FoodAppImageConstants)
        
        case apple(_ model: SignUpOptionModel)
        case google(_ model: SignUpOptionModel)
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
    
    init() {
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
    
    private func setupDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.main])
        snapshot.appendItems([
            .logo(.apple_logo),
            .apple(SignUpOptionModel(imageConstant: .apple_logo, description: "Sign up with Apple")),
            .google(SignUpOptionModel(imageConstant: .google_logo, description: "Sign up with Google")),
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
    
    private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell? {
        
        switch row {
        case .logo(let image):
            return tableView.configuredCell(SignUpLogoCell.self) { cell in
                cell.configure(image: image.image)
            }
        case .apple(let model), .google(let model), .facebook(let model), .email(let model):
            return tableView.configuredCell(SignUpOptionCell.self) { cell in
                cell.configure(image: model.imageConstant?.image, description: model.description)
            }
        case .signIn:
            return tableView.configuredCell(SignInCell.self) { cell in
                cell.configure()
            }
        }
    }
}
