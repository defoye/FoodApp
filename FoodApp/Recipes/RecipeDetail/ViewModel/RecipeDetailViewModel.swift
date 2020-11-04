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
	case similarRecipes
}

class RecipeDetailViewModel {
	
	let dataManager = RecipeDataManager()
	
	var isLoading: Bool = false
	
	let urlParam: String
	let idParam: Int?
	
	var items: [RecipeDetailSection: Any]? = [:]
    var searchOriginalObject: RecipesViewModel.Item?
    var similarOriginalObject: SimilarRecipeItem?
    var firebaseOriginalObject: FirebaseAPI.TopRecipesSearchResults.ResponseModel?
    
    var extractModel: SpoonacularAPI.ExtractRecipeModel?

    init(_ urlParam: String, _ item: RecipesViewModel.Item) {
		self.urlParam = urlParam
		self.idParam = item.id
		self.items?[.header] = HeaderItem(title: item.title ?? "Error", image: item.image)
        self.searchOriginalObject = item
	}
	
	init(_ urlParam: String, _ item: SimilarRecipeItem) {
		self.urlParam = urlParam
		self.idParam = item.id
		self.items?[.header] = HeaderItem(title: item.title, image: item.image)
        self.similarOriginalObject = item
	}
    
    init(_ item: FirebaseAPI.TopRecipesSearchResults.ResponseItem) {
        self.urlParam = item.responseModel.sourceURL
        self.idParam = item.responseModel.id
        self.items?[.header] = HeaderItem(title: item.responseModel.title, image: item.image)
        self.firebaseOriginalObject = item.responseModel
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
		case .similarRecipes:
			if let items = items?[.similarRecipes] as? [SimilarRecipeItem] {
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
	
	func similarRecipeItem(at index: Int) -> SimilarRecipeItem? {
		(items?[.similarRecipes] as? [SimilarRecipeItem])?[index]
	}
	
	func fetchData(_ completion: @escaping (() -> Void)) {		
		loadRecipeDetails(completion)
		loadSimilarRecipes(completion)
	}
	
	private func loadRecipeDetails(_ completion: @escaping (() -> Void)) {
		isLoading = true

        dataManager.extractRecipeSearch([.url: urlParam]) { (status, model) in
            self.isLoading = false
            switch status {
            case .success:
                if let model = model {
                    self.extractModel = model
                    self.createItems(model, completion)
                }
            case .error:
                fatalError("API ran out")
            }
        }
	}
	
	private func loadSimilarRecipes(_ completion: @escaping (() -> Void)) {
		guard let id = idParam else {
			return
		}
		isLoading = true
        dataManager.recipeSimilarSearch([.id: String(id)]) { [weak self] (status, model) in
			guard let self = self else { return }
			self.isLoading = false
			switch status {
			case .success:
				if let model = model {
					self.createSimilarRecipeItems(model, completion)
				}
			case .error:
				break
			}
		}
	}
	
	func createSimilarRecipeItems(_ model: SpoonacularAPI.RecipeSimilarModel, _ completion: @escaping (() -> Void)) {
        FirebaseDataManager.shared.addRecipeSearchData(model)

		var similarItems: [SimilarRecipeItem] = []
		
		let dGroup = DispatchGroup()
		
		isLoading = true
		
		model.forEach { (element) in
            var item = SimilarRecipeItem(element, image: nil)
            guard let imageURL = item.imageURL else {
                return
            }
            dGroup.enter()
            dataManager.downloadImage(from: imageURL) { (image) in
                if let image = image {
                    item.image = image
                    similarItems.append(item)
                }
                dGroup.leave()
            }
		}
		
		dGroup.notify(queue: .main) {
			self.isLoading = false
			self.items?[.similarRecipes] = similarItems
			completion()
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
	
    struct IngredientItem: Codable {
		
		let originalName: String
		let name: String
		let amount: Double
		let unit: String
		
		let primaryTitleLabelText: String
		let secondaryTitleLabelText: String
		
		let usValue: Double
		let usUnit: String
		
		let metricValue: Double
		let metricUnit: String
		
		init(_ obj: SpoonacularAPI.ExtendedIngredient) {
			originalName = obj.original ?? obj.originalString ?? "Error"
			
			name = obj.name ?? "Error"
			amount = obj.amount ?? -1
			unit = obj.unit ?? "Error"
			
			primaryTitleLabelText = "\(name.capitalized), \(amount.roundedFractionString()) \(unit)"
			secondaryTitleLabelText = originalName.capitalized
			
			metricValue = obj.measures?.metric?.value ?? 0
			metricUnit = obj.measures?.metric?.unit ?? ""
			usValue = obj.measures?.us?.value ?? 0
			usUnit = obj.measures?.us?.unit ?? ""
		}
        
        enum Param: String {
            case originalName
            case name
            case amount
            case unit
            
            case primaryTitleLabelText
            case secondaryTitleLabelText
            
            case usValue
            case usUnit
            
            case metricValue
            case metricUnit
        }
        
        func toDict() -> [String: String] {
            var paramDict: [Param: String] = [:]
            
            paramDict[.originalName] = originalName
            paramDict[.name] = name
            paramDict[.amount] = String(amount)
            paramDict[.unit] = unit
            paramDict[.primaryTitleLabelText] = primaryTitleLabelText
            paramDict[.secondaryTitleLabelText] = secondaryTitleLabelText
            paramDict[.usValue] = String(usValue)
            paramDict[.usUnit] = usUnit
            paramDict[.metricValue] = String(metricValue)
            paramDict[.metricUnit] = metricUnit

            return paramDict.convertedToRawValues()
        }
	}
	
	struct SimilarRecipeItem {
		
		let title: String
		let timeTitle: String
		
		var image: UIImage?
		
		let id: Int?
		let sourceURL: String?
        
        let imageURL: String?
        let readyInMinutes: Int?
		
		init(_ obj: SpoonacularAPI.RecipeSimilarModelElement, image: UIImage?) {
			title = obj.title ?? "Error"
			if let minutes = obj.readyInMinutes {
				timeTitle = minutes.minutesIntToTimeString()
			} else {
				timeTitle = "Error"
			}
			self.image = image
			id = obj.id
			sourceURL = obj.sourceURL
            if let id = obj.id, let imageType = obj.imageType {
                let size = "240x150"
                self.imageURL = "https://spoonacular.com/recipeImages/\(id)-\(size).\(imageType)"
            } else {
                self.imageURL = ""
            }
            self.readyInMinutes = obj.readyInMinutes
		}
	}
}
