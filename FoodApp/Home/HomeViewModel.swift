//
//  HomeViewModel.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import QuiteAdaptableKit

class HomeViewModel {
    
    typealias Item = HomeViewController.Item
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewController.Section, Item>
    
    var dataSourceApplyBlock: ((Snapshot) -> Void)?
    
    var snapshot: Snapshot = {
        var snapshot = Snapshot()
        snapshot.appendSections([.topRecipes])
        return snapshot
    }()
    
    func fetchData() {
        fetchTopRecipes()
    }
    
    private func fetchTopRecipes() {
        let fetchAmount = Constants.Ints.homeTopRecipesCount.rawValue
        FirebaseDataManager.shared.fetchTopRecipes(numberOfResults: fetchAmount) { models in
            self.snapshot.appendItems([.labelItem(self.topRecipesLabelModel())])
            let items = self.createTopRecipesItems(fromModels: models)
            self.snapshot.appendItems(items)
            items.forEach { item in
                if case .topRecipesItem(let model) = item {
                    RecipeDataManager.shared.downloadImage(from: model.imageURL) { image in
                        if let image = image {
                            model.image = image
                            self.snapshot.reloadItems([item])
                            self.dataSourceApplyBlock?(self.snapshot)
                        }
                    }
                }
            }
            self.dataSourceApplyBlock?(self.snapshot)
        }
    }
    
    private func topRecipesLabelModel() -> LabelCell.Model {
        let labelItemModel = LabelCell.Model()
        labelItemModel.text = "Top Searched Recipes"
        labelItemModel.font = .systemFont(ofSize: 30)
        labelItemModel.alignment = .left
        labelItemModel.textInsets = .init(top: 0, left: 20, bottom: -10, right: -20)
        return labelItemModel
    }
    
    private func createTopRecipesItems(fromModels models: [FirebaseAPI.TopRecipesSearchResults.ResponseModel]) -> [Item] {
        var items = models.map { model -> Item in
            return .topRecipesItem(model)
        }

        for i in stride(from: items.count - 1, through: 1, by: -1) {
            items.insert(.separatorItem(UUID()), at: i)
        }
        
        return items
    }
}
