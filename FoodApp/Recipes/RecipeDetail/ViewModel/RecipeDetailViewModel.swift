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
    
    typealias Section = RecipeDetailViewController.Section
    typealias Item = RecipeDetailViewController.Item
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

	let dataManager = RecipeDataManager()
	
    var isLoadingRecipeDetail: Bool = true {
        didSet {
            callFavoriteButtonEnableBlock()
        }
    }
    var isLoadingFavoriteRecipe: Bool = false {
        didSet {
            callFavoriteButtonEnableBlock()
        }
    }
    var dataSourceApplyBlock: ((Snapshot) -> Void)?
    var favoriteButtonEnableBlock: ((_ isLoading: Bool, _ isFavoriteRecipe: Bool) -> Void)?
    var isFavoriteRecipe: Bool = false
	var isLoadingSimilarRecipes: Bool = false
	let urlParam: String
	let idParam: Int?

    lazy var snapshot: Snapshot = {
        var snapshot = Snapshot()
        snapshot.appendSections([.header, .ingredients, .instructions, .similarRecipes])
        return snapshot
    }()
    var searchOriginalObject: RecipesViewModel.Item?
    var similarOriginalObject: SimilarRecipeItem?
    var firebaseOriginalObject: FirebaseAPI.TopRecipesSearchResults.ResponseModel?
    var extractModel: SpoonacularAPI.ExtractRecipeModel?

    init(_ urlParam: String, _ item: RecipesViewModel.Item) {
		self.urlParam = urlParam
		self.idParam = item.id
        self.snapshot.appendItems([.header(HeaderItem(title: item.title ?? "Error", image: item.image))], toSection: .header)
        self.searchOriginalObject = item
	}
	
	init(_ urlParam: String, _ item: SimilarRecipeItem) {
		self.urlParam = urlParam
		self.idParam = item.id
        self.snapshot.appendItems([.header(HeaderItem(title: item.title, image: item.image))], toSection: .header)

        self.similarOriginalObject = item
	}
    
    init(_ item: FirebaseAPI.TopRecipesSearchResults.ResponseItem) {
        self.urlParam = item.responseModel.sourceURL
        self.idParam = item.responseModel.id
        self.snapshot.appendItems([.header(HeaderItem(title: item.responseModel.title, image: item.image))], toSection: .header)

        self.firebaseOriginalObject = item.responseModel
    }
	
	func fetchData() {
        fetchIsFavoriteRecipe()
		loadRecipeDetails()
		loadSimilarRecipes()
	}
    
    private func callFavoriteButtonEnableBlock() {
        if isLoadingFavoriteRecipe {
            favoriteButtonEnableBlock?(isLoadingRecipeDetail, false)
        } else {
            favoriteButtonEnableBlock?(isLoadingRecipeDetail, isFavoriteRecipe)
        }
    }
    
    private func fetchIsFavoriteRecipe() {
        self.isLoadingFavoriteRecipe = true
        let fetch: (Int) -> Void = { id in
            FirebaseDataManager.shared.fetchIsFavoriteRecipe(id) { isFavoriteRecipe in
                self.isFavoriteRecipe = isFavoriteRecipe
                self.isLoadingFavoriteRecipe = false
            }
        }
        
        if let id = searchOriginalObject?.id {
            fetch(id)
        }
        if let id = similarOriginalObject?.id {
            fetch(id)
        }
        if let id = firebaseOriginalObject?.id {
            fetch(id)
        }
    }
	
	private func loadRecipeDetails() {
		isLoadingRecipeDetail = true
        
        let completion: (RequestStatus, SpoonacularAPI.ExtractRecipeModel?) -> Void = { status, model in
            self.isLoadingRecipeDetail = false
            switch status {
            case .success:
                if let model = model {
                    self.extractModel = model
                    self.createItems(model)
                }
            case .error:
                self.snapshot.appendItems([.error("Error loading recipe details")], toSection: .ingredients)
            }
        }

        if let extractRecipeModel = self.extractModel {
            completion(.success, extractRecipeModel)
        } else {
            dataManager.extractRecipeSearch([.url: urlParam]) { (status, model) in
                completion(status, model)
            }
        }
	}
	
	private func loadSimilarRecipes() {
		guard let id = idParam else {
			return
		}
		isLoadingSimilarRecipes = true
        dataManager.recipeSimilarSearch([.id: String(id)]) { [weak self] (status, model) in
			guard let self = self else { return }
			self.isLoadingSimilarRecipes = false
			switch status {
			case .success:
				if let model = model {
					self.createSimilarRecipeItems(model)
				}
			case .error:
				break
			}
		}
	}
    
    private func headerLabelModel(_ title: String) -> LabelCell.Model {
        let labelItemModel = LabelCell.Model()
        labelItemModel.text = title
        labelItemModel.font = UIFont(name: "Avenir-Heavy", size: 24)
        labelItemModel.alignment = .left
        labelItemModel.textInsets = .init(top: 0, left: 20, bottom: -10, right: -20)
        return labelItemModel
    }
	
	func createSimilarRecipeItems(_ model: SpoonacularAPI.RecipeSimilarModel) {
        FirebaseDataManager.shared.addRecipeSearchData(model)
                
        snapshot.appendItems([.labelItem(headerLabelModel("Similar Recipes"))], toSection: .similarRecipes)
        var items = model.map { recipe -> Item in
            return .similarRecipe(SimilarRecipeItem(recipe, image: nil))
        }
        items = addSeparatorItems(fromItems: items, .short)
        self.snapshot.appendItems(items, toSection: .similarRecipes)
        items.forEach { item in
            if case .similarRecipe(let model) = item {
                guard let imageURL = model.imageURL else {
                    return
                }
                RecipeDataManager.shared.downloadImage(from: imageURL) { image in
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
    
    private func addSeparatorItems(fromItems items: [Item], _ style: Item.Style) -> [Item] {
        var items = items
        for i in stride(from: items.count - 1, through: 1, by: -1) {
            items.insert(.separatorItem(UUID(), style), at: i)
        }
        
        return items
    }
	
	func createItems(_ model: SpoonacularAPI.ExtractRecipeModel) {
		if let instructions = model.analyzedInstructions, instructions.count > 0, let steps = instructions[0].steps {
            var items = steps.map { step -> Item in
                return .instruction(InstructionItem(step))
            }
            items = addSeparatorItems(fromItems: items, .long)
            snapshot.appendItems([.labelItem(headerLabelModel("Instructions"))], toSection: .instructions)
            snapshot.appendItems(items, toSection: .instructions)
		}
        		
		if let ingredients = model.extendedIngredients {
			var items = ingredients.map { ingredient -> Item in
                return .ingredient(IngredientItem(ingredient))
            }
            items = addSeparatorItems(fromItems: items, .long)
            snapshot.appendItems([.labelItem(headerLabelModel("Ingredients"))], toSection: .ingredients)
            snapshot.appendItems(items, toSection: .ingredients)
		}
		
		dataSourceApplyBlock?(snapshot)
	}
}

extension RecipeDetailViewModel {
	
    struct HeaderItem: Hashable {
        let uuid = UUID()
		let title: String
		let image: UIImage?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        static func == (lhs: HeaderItem, rhs: HeaderItem) -> Bool {
            return lhs.uuid == rhs.uuid
        }
	}
	
    struct InstructionItem: Hashable {
        
        let uuid = UUID()
		
		let number: String
		let stepTitle: String
		
		init(_ obj: SpoonacularAPI.Step) {
			self.number = String(obj.number ?? 0)
			self.stepTitle = obj.step ?? "Error"
		}
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        static func == (lhs: InstructionItem, rhs: InstructionItem) -> Bool {
            return lhs.uuid == rhs.uuid
        }
	}
	
    struct IngredientItem: Codable, Hashable {
		
        let uuid = UUID()
        
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
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        static func == (lhs: IngredientItem, rhs: IngredientItem) -> Bool {
            return lhs.uuid == rhs.uuid
        }
	}
	
    class SimilarRecipeItem: Hashable {
		
        let uuid = UUID()
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
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        static func == (lhs: SimilarRecipeItem, rhs: SimilarRecipeItem) -> Bool {
            return lhs.uuid == rhs.uuid
        }
	}
}
