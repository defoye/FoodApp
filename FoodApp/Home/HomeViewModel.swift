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
        snapshot.appendSections([.topRecipes, .favoriteRecipes])
        return snapshot
    }()
    
    func fetchData() {
        fetchTopRecipes()
        fetchFavoriteRecipes()
    }
    
    private func fetchTopRecipes() {
        let fetchAmount = Constants.Ints.homeTopRecipesCount.rawValue
        FirebaseDataManager.shared.fetchTopRecipes(numberOfResults: fetchAmount) { models in
            let items = self.createTopRecipesItems(fromModels: models)
            if items.count > 0 {
                self.snapshot.appendItems([.labelItem(self.headerLabelModel("Top Searched Recipes"))], toSection: .topRecipes)
            }
            self.snapshot.appendItems(items, toSection: .topRecipes)
            items.forEach { item in
                if case .topRecipesItem(let model) = item {
                    RecipeDataManager.shared.downloadImage(from: model.responseModel.imageURL) { image in
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
    
    private func fetchFavoriteRecipes() {
        FirebaseDataManager.shared.fetchFavoriteRecipes(numberOfResults: 3) { models in
            let items = self.createFavoriteRecipesItems(fromModels: models)
            if items.count > 0 {
                self.snapshot.appendItems([.labelItem(self.headerLabelModel("Favorite Recipes"))], toSection: .favoriteRecipes)
            }
            self.snapshot.appendItems(items, toSection: .favoriteRecipes)
            items.forEach { item in
                if case .favoriteRecipesItem(let model) = item {
                    RecipeDataManager.shared.downloadImage(from: model.responseModel.imageURL) { image in
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
    
    private func headerLabelModel(_ title: String) -> LabelCell.Model {
        let labelItemModel = LabelCell.Model()
        labelItemModel.text = title
        labelItemModel.font = .systemFont(ofSize: 24)
        labelItemModel.alignment = .left
        labelItemModel.textInsets = .init(top: 0, left: 20, bottom: -10, right: -20)
        return labelItemModel
    }
    
    private func createTopRecipesItems(fromModels models: [FirebaseAPI.TopRecipesSearchResults.ResponseModel]) -> [Item] {
        let items = models.map { model -> Item in
            return .topRecipesItem(FirebaseAPI.TopRecipesSearchResults.ResponseItem(model))
        }
        
        return addSeparatorItems(fromItems: items)
    }
    
    private func createFavoriteRecipesItems(fromModels models: [FirebaseAPI.FavoriteRecipes.ResponseModel]) -> [Item] {
        let items = models.compactMap { model -> Item? in
            guard let responseModel = model.responseModel else {
                return nil
            }
            return .favoriteRecipesItem(FirebaseAPI.TopRecipesSearchResults.ResponseItem(responseModel))
        }
        
        return addSeparatorItems(fromItems: items)
    }
    
    private func addSeparatorItems(fromItems items: [Item]) -> [Item] {
        var items = items
        for i in stride(from: items.count - 1, through: 1, by: -1) {
            items.insert(.separatorItem(UUID()), at: i)
        }
        
        return items
    }
}
