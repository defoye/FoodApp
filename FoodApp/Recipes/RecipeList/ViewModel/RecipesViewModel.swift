//
//  RecipesViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class RecipesViewModel {
	
    let dataManager = RecipeDataManager.shared
	var offset: Int = 0
	var fetchAmount: Int = 20
	var isLoading: Bool = false
	var items: [Item]?
    var totalResults: Int = 0

    let passThroughParams: SpoonacularAPI.ComplexSearch.ParamDict
	
	init(_ passThroughData: SpoonacularAPI.ComplexSearch.ParamDict) {
		passThroughParams = passThroughData
	}
	
    func loadComplexRecipes(_ params: SpoonacularAPI.ComplexSearch.ParamDict, _ completion: @escaping (() -> Void)) {
		isLoading = true
		dataManager.recipeComplexSearch(params) { [weak self] (status, model) in
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
	
    func createParams(instructionsRequired: Bool) -> SpoonacularAPI.ComplexSearch.ParamDict {
        let paramDict: SpoonacularAPI.ComplexSearch.ParamDict = [
            .offset: String(offset),
            .number: String(fetchAmount),
            .instructionsRequired: String(instructionsRequired),
            .addRecipeInformation: "true"
        ]
        
        return passThroughParams.merged(with: paramDict)
	}
		
	func createItems(_ model: SpoonacularAPI.RecipeComplexSearchModel, _ completion: @escaping (() -> Void)) {
		guard let recipes = model.results else {
			return
		}
        FirebaseDataManager.shared.addRecipeSearchData(recipes)
		totalResults = model.totalResults ?? 0
		let dGroup = DispatchGroup()
		
		var items: [Item] = []
		
		isLoading = true
		
		recipes.forEach { recipe in
			if var imageURLString = recipe.image {
				dGroup.enter()
				dataManager.downloadImage(from: imageURLString) { image in
					if let image = image {
						let ratio = image.size.width / image.size.height
						if abs(ratio - 1) <= 0.5 {
							items.append(Item(recipe, image: image))
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
	
	func item(for row: Int) -> Item? {
		let count = items?.count ?? 0
		if row >= count { return nil }
		return items?[row]
	}
}

import UIKit

extension RecipesViewModel {
	
	struct Item {
		let title: String?
		let timeTitle: String
		let sourceURL: String?
		
		let id: Int?
		
		let image: UIImage
		
		init(_ obj: SpoonacularAPI.RecipeComplexSearchResult, image: UIImage) {
			self.id = obj.id
			self.title = obj.title
			if let minutes = obj.readyInMinutes {
				timeTitle = minutes.minutesIntToTimeString()
			} else {
				timeTitle = "Error"
			}
			self.sourceURL = obj.sourceURL
			self.image = image
		}
	}
}
