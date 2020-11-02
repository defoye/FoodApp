//
//  HomeViewController.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case recipeSimilar(_ model: FirebaseAPI.TopRecipesSearchResults.ResponseModel)
    }
    
    lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .recipeSimilar(let model):
                return tableView.configuredCell(RecipePreviewTableViewCell.self, identifier: RecipePreviewTableViewCell.reuseIdentifier) { cell in
                    cell.configure(model)
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
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        view.backgroundColor = .blue
            
        view.addSubview(tableView)
        tableView.pin(to: view.safeAreaLayoutGuide)

        self.title = "Home"
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.main])
        
        let fetchAmount = Constants.Ints.homeTopRecipesCount.rawValue
        FirebaseDataManager.shared.fetchTopRecipes(numberOfResults: fetchAmount) { models in
            let items = models.map { model -> Item in
                return .recipeSimilar(model)
            }
            snapshot.appendItems(items)
            self.dataSource.apply(snapshot)
            items.forEach { item in
                switch item {
                case .recipeSimilar(let model):
                    RecipeDataManager.shared.downloadImage(from: model.imageURL) { image in
                        if let image = image {
                            let ratio = image.size.width / image.size.height
                            if abs(ratio - 1) <= 0.5 {
                                model.image = image
                                snapshot.reloadItems([item])
                                self.dataSource.apply(snapshot)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
}
