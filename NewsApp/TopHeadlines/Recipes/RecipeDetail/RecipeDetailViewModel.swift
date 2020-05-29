//
//  RecipeDetailViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

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
	
	init(_ urlParam: String, _ item: RecipesViewModel.Item) {
		self.urlParam = urlParam
		self.items?[.header] = HeaderItem(title: item.title ?? "Error", image: item.image)
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
			self.isLoading = false
			switch status {
			case .success:
				if let model = model {
					self.createItems(model, completion)
				}
			case .error:
				fatalError()
			}
		}
	}
	
	func createItems(_ model: SpoonacularAPI.ExtractRecipeModel, _ completion: @escaping (() -> Void)) {
		
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
		
//		if let title = model.title, let imageURL = model.image {
//			items?[.header] = HeaderItem(title: title, image: nil)
//
//			dataManager.downloadImage(from: imageURL) { (image) in
//				if let image = image {
//					self.items?[.header] = HeaderItem(title: title, image: image)
//				}
//				completion()
//			}
//		}
		
		items?[.instructions] = instructionItems
		items?[.ingredients] = ingredientItems
		
		completion()
	}
}

extension RecipeDetailViewModel {
	
	struct HeaderItem {
		let title: String
		let image: UIImage?
	}
	
	struct InstructionItem {
		
		let number: String
		let stepTitle: String
		
		init(_ obj: SpoonacularAPI.Step) {
			self.number = String(obj.number ?? 0)
			self.stepTitle = obj.step ?? "Error"
		}
	}
	
	struct IngredientItem {
		
		let originalName: String
		let name: String
		let amount: Double
		let unit: String
		
		let primaryTitleLabelText: String
		let secondaryTitleLabelText: String
		
		let usValue: Double?
		let usUnit: String?
		
		let metricValue: Double?
		let metricUnit: String?
		
		init(_ obj: SpoonacularAPI.ExtendedIngredient) {
			originalName = obj.original ?? obj.originalString ?? "Error"
			
			name = obj.name ?? "Error"
			amount = obj.amount ?? -1
			unit = obj.unit ?? "Error"
			
			primaryTitleLabelText = "\(name.capitalized), \(amount.roundedFractionString()) \(unit)"
			secondaryTitleLabelText = originalName.capitalized
			
			metricValue = obj.measures?.metric?.value
			metricUnit = obj.measures?.metric?.unit
			usValue = obj.measures?.us?.value
			usUnit = obj.measures?.us?.unit
		}
	}
}

extension Double {
	
	struct Rational {
		let numerator : Int
		let denominator: Int

		init(numerator: Int, denominator: Int) {
			self.numerator = numerator
			self.denominator = denominator
		}

		init(approximating x0: Double, withPrecision eps: Double = 1.0E-6) {
			var x = x0
			var a = x.rounded(.down)
			var (h1, k1, h, k) = (1, 0, Int(a), 1)

			while x - a > eps * Double(k) * Double(k) {
				x = 1.0/(x - a)
				a = x.rounded(.down)
				(h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
			}
			self.init(numerator: h, denominator: k)
		}
	}
	
	func roundedFractionString() -> String {
		let rational = Rational(approximating: self)
		
		if rational.numerator == rational.denominator {
			return String(Int(self))
		} else if rational.denominator == 1 {
			return String(rational.numerator)
		}
		
		return "\(rational.numerator)/\(rational.denominator)"
	}
}
