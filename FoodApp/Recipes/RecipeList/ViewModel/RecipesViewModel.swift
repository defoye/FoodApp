//
//  RecipesViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class RecipesViewModel {
	
	let dataManager = RecipeDataManager()
	var offset: Int = 0
	var fetchAmount: Int = 20
	var isLoading: Bool = false
	var items: [Item]?

	let passThroughParams: [String: String]
	
	init(_ passThroughData: [String: String]) {
		passThroughParams = passThroughData
	}
	
//	func loadRecipes(_ params: [String: String], _ completion: @escaping (() -> Void)) {
//		isLoading = true
//		dataManager.recipeSearch(params) { [weak self] (status, model) in
//			guard let self = self else { return }
//			self.isLoading = false
//			self.offset += self.fetchAmount
//			switch status {
//			case .success:
//				if let model = model {
//					self.createItems(model, completion)
//				}
//			case .error:
//				break
//			}
//		}
//	}
	
	func loadComplexRecipes(_ params: [String: String], _ completion: @escaping (() -> Void)) {
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
	
	func createParams(instructionsRequired: Bool) -> [String: String] {
		return passThroughParams.merged(with: [
			"offset": String(offset),
			"number": String(fetchAmount),
			"instructionsRequired": String(instructionsRequired),
			"addRecipeInformation": "true"
		])
	}
	
	var totalResults: Int = 0
		
//	func createItems(_ model: SpoonacularAPI.RecipeSearchModel, _ completion: @escaping (() -> Void)) {
//		guard let recipes = model.results else {
//			return
//		}
//		totalResults = model.totalResults ?? 0
//		let dGroup = DispatchGroup()
//
//		var items: [Item] = []
//
//		isLoading = true
//
//		recipes.forEach { recipe in
//			if var imageURLString = recipe.image {
//				imageURLString = "https://spoonacular.com/recipeImages/" + imageURLString
//				dGroup.enter()
//				dataManager.downloadImage(from: imageURLString) { image in
//					if let image = image {
//						let ratio = image.size.width / image.size.height
//						if abs(ratio - 1) <= 0.5 {
//							items.append(Item(recipe, image: image))
//						}
//					}
//					dGroup.leave()
//				}
//			}
//		}
//
//		dGroup.notify(queue: .main) {
//			self.isLoading = false
//			self.items = (self.items ?? []) + items
//			completion()
//		}
//	}
	
	func createItems(_ model: SpoonacularAPI.RecipeComplexSearchModel, _ completion: @escaping (() -> Void)) {
		guard let recipes = model.results else {
			return
		}
		totalResults = model.totalResults ?? 0
		let dGroup = DispatchGroup()
		
		var items: [Item] = []
		
		isLoading = true
		
		recipes.forEach { recipe in
			if var imageURLString = recipe.image {
//				imageURLString = "https://spoonacular.com/recipeImages/" + imageURLString
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
//	struct Item {
//		let title: String?
//		let timeTitle: String
//		let sourceURL: String?
//
//		let image: UIImage
//
//		init(_ obj: SpoonacularAPI.Result, image: UIImage) {
//			self.title = obj.title
//			if let minutes = obj.readyInMinutes {
//				let hours = Int(Double(minutes) / 60)
//				let days = Int((Double(minutes) / 60) / 24)
//
//				if days > 0 {
//					if days == 1 {
//						timeTitle = "1 day"
//					} else {
//						timeTitle = "\(days) days"
//					}
//				} else if hours > 0 {
//					if hours == 1 {
//						timeTitle = "1 hour"
//					} else {
//						timeTitle = "\(hours) hours"
//					}
//				} else {
//					if minutes == 1 {
//						timeTitle = "1 minute"
//					} else {
//						timeTitle = "\(minutes) minutes"
//					}
//				}
//			} else {
//				timeTitle = ""
//			}
//			self.sourceURL = obj.sourceURL
//			self.image = image
//		}
//	}
	
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