//
//  HomeViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate {
    
    enum Section {
        case topRecipes
    }
    
    enum Item: Hashable {
        case topRecipesItem(_ model: FirebaseAPI.TopRecipesSearchResults.ResponseModel)
        case separatorItem(_ uuid: UUID)
    }
    
    lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .topRecipesItem(let model):
                return tableView.configuredCell(RecipePreviewTableViewCell.self, identifier: RecipePreviewTableViewCell.reuseIdentifier) { cell in
                    cell.configure(model)
                }
            case .separatorItem:
                return tableView.configuredCell(BlankTableViewCell.self) { cell in
                    let view = UIView()
                    view.backgroundColor = .lightGray
                    view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                    let setupModel = BlankTableViewCell.SetupModel()
                    let viewModel = BlankTableViewCell.ViewModel()
                    viewModel.viewInsets = .init(top: 0, left: 110, bottom: 0, right: 0)
                    cell.configure(view, setupModel: setupModel, viewModel: viewModel)
                }
            }
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RecipePreviewTableViewCell.self, forCellReuseIdentifier: RecipePreviewTableViewCell.reuseIdentifier)
        tableView.register(BlankTableViewCell.self, forCellReuseIdentifier: "BlankTableViewCell")
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    let viewModel: HomeViewModel
    
    init() {
        self.viewModel = HomeViewModel()
        super.init(nibName: nil, bundle: nil)
        setupTabBar()
        tableView.dataSource = dataSource
        self.viewModel.dataSourceApplyBlock = { [weak self] snapshot in
            guard let self = self else {
                return
            }
            self.dataSource.apply(snapshot)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviewsAndConstraints()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Home"
    }
    
    private func setupTabBar() {
        tabBarItem = UITabBarItem(title: "Home", image: Constants.Images.home.image, selectedImage: nil)
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableView)
        tableView.pin(to: view)
    }
}
