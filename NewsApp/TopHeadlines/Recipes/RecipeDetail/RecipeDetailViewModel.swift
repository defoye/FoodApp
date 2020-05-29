//
//  RecipeDetailViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum RecipeDetailSection: Int, CaseIterable {
	case header
	case ingredients
	case instructions
}

class RecipeDetailViewModel {
	
	let dataManager = NewsAppDataManager()
	
	var isLoading: Bool = false
	
	let urlParam: String
	
	var items: [RecipeDetailSection: Any]? = [:]
	
	init(_ urlParam: String) {
		self.urlParam = urlParam
	}
	
	func numberOfRows(in section: RecipeDetailSection) -> Int {
		switch section {
		case .header:
			return 1
		case .ingredients:
			if let items = items?[.ingredients] as? [IngredientItem] {
				return items.count
			}
		case .instructions:
			if let items = items?[.instructions] as? [InstructionItem] {
				return items.count
			}
		}
		
		return 0
	}
	
	func headerItem() -> HeaderItem? {
		return items?[.header] as? HeaderItem
	}
	
	func ingredientItem(at index: Int) -> IngredientItem? {
		(items?[.ingredients] as? [IngredientItem])?[index]
	}
	
	func instructionItem(at index: Int) -> InstructionItem? {
		(items?[.instructions] as? [InstructionItem])?[index]
	}
	
	func loadRecipeDetails(_ completion: @escaping (() -> Void)) {
		isLoading = true
		dataManager.extractRecipeSearch(["url": urlParam]) { (status, model) in
			self.isLoading = true
			switch status {
			case .success:
				if let model = model {
					self.createItems(model)
					completion()
				}
			case .error:
				fatalError()
			}
		}
	}
	
	func createItems(_ model: SpoonacularAPI.ExtractRecipeModel) {
		
		var instructionItems: [InstructionItem] = []
		var ingredientItems: [IngredientItem] = []
		
		if let instructions = model.analyzedInstructions, instructions.count > 0, let steps = instructions[0].steps {
			steps.forEach { (step) in
				instructionItems.append(InstructionItem(step))
			}
		}
		
		if let ingredients = model.extendedIngredients {
			ingredients.forEach { ingredient in
				ingredientItems.append(IngredientItem(ingredient))
			}
		}
		
		if let title = model.title, let imageURL = model.image {
			items?[.header] = HeaderItem(title: title, imageURL: imageURL)
		}
		
		items?[.instructions] = instructionItems
		items?[.ingredients] = ingredientItems
	}
}

extension RecipeDetailViewModel {
	
	struct HeaderItem {
		let title: String
		let imageURL: String
	}
	
	struct InstructionItem {
		
		let number: String?
		let stepTitle: String?
		
		init(_ obj: SpoonacularAPI.Step) {
			self.number = String(obj.number ?? 0)
			self.stepTitle = obj.step
		}
	}
	
	struct IngredientItem {
		
		let usValue: Double?
		let usUnit: String?
		
		let metricValue: Double?
		let metricUnit: String?
		
		init(_ obj: SpoonacularAPI.ExtendedIngredient) {
			metricValue = obj.measures?.metric?.value
			metricUnit = obj.measures?.metric?.unit
			usValue = obj.measures?.us?.value
			usUnit = obj.measures?.us?.unit
		}
	}
}

