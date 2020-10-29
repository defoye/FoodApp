//
//  EdamamRecipesViewModel.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

struct EdamamRecipeItem: Hashable {
    
    let uuid = UUID()
    
    let image: UIImage
    let url: String
    let ingredients: [EdamamAPI.Ingredient]
    let totalTime: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: EdamamRecipeItem, rhs: EdamamRecipeItem) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

class EdamamRecipesViewModel {
    
    let dataManager = EdamamDataManager()
    var offset: Int = 0
    var fetchAmount: Int = 20
    var isLoading: Bool = false
    var items: [EdamamRecipeItem]?
    var totalResults: Int = 0

    let passThroughParams: [String: String]
    
    init(_ passThroughData: [String: String]) {
        passThroughParams = passThroughData
    }
    
    func loadComplexRecipes(_ params: [String: String], _ completion: @escaping (() -> Void)) {
        isLoading = true
        dataManager.recipeSearch(params) { [weak self] (status, model) in
            guard let self = self else { return }
            self.isLoading = false
            self.offset += self.fetchAmount
            switch status {
            case .success:
                if let model = model {
                    self.createItems(model, completion)
                }
            case .error:
                break
            }
        }
    }
    
    var hasMoreContent: Bool {
        return offset < totalResults
    }
    
    func createParams(query: String) -> [String: String] {
        return passThroughParams.merged(with: [
            "q": query,
            "from": String(offset),
            "to": String(offset + fetchAmount)
        ])
    }
        
    func createItems(_ model: EdamamAPI.RecipeSearchModel, _ completion: @escaping (() -> Void)) {
        let recipes = (model.hits ?? []).compactMap { $0.recipe }
        
        totalResults = model.count ?? 0
        let dGroup = DispatchGroup()
        
        var items: [EdamamRecipeItem] = []
        
        isLoading = true
        
        recipes.forEach { recipe in
            if var imageURLString = recipe.image {
                dGroup.enter()
                dataManager.downloadImage(from: imageURLString) { image in
                    if let image = image, let url = recipe.url, let ingredients = recipe.ingredients, let totalTime = recipe.totalTime {
                        let ratio = image.size.width / image.size.height
                        if abs(ratio - 1) <= 0.5 {
                            let item = EdamamRecipeItem(image: image, url: recipe.url ?? "", ingredients: ingredients, totalTime: totalTime)
                            items.append(item)
                        }
                    }
                    dGroup.leave()
                }
            }
        }
        
        dGroup.notify(queue: .main) {
            self.isLoading = false
            self.items = (self.items ?? []) + items
            completion()
        }
    }
    
    func numberOfItems(in section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func item(for row: Int) -> EdamamRecipeItem? {
        let count = items?.count ?? 0
        if row >= count { return nil }
        return items?[row]
    }
}
