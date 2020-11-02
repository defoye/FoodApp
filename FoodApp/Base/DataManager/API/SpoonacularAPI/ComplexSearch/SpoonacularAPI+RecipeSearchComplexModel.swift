//
//  SpoonacularAPI+RecipeSearchComplexModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {

	// MARK: - RecipeComplexSearchModel
	struct RecipeComplexSearchModel: Codable {
		let results: [RecipeComplexSearchResult]?
		let offset, number, totalResults: Int?
	}

	// MARK: - Result
	struct RecipeComplexSearchResult: Codable {
		let vegetarian, vegan, glutenFree, dairyFree: Bool?
		let veryHealthy, cheap, veryPopular, sustainable: Bool?
		let weightWatcherSmartPoints: Int?
		let gaps: Gaps?
		let lowFodmap: Bool?
		let preparationMinutes, cookingMinutes, aggregateLikes, spoonacularScore: Int?
		let healthScore: Int?
		let creditsText, sourceName: String?
		let pricePerServing: Double?
		let id: Int?
		let title: String?
		let readyInMinutes, servings: Int?
		let sourceURL: String?
		let image: String?
		let imageType: ImageType?
		let summary: String?
		let cuisines: [String]?
		let dishTypes: [DishType]?
//		let diets: [Diet]?
		let occasions: [String]?
		let winePairing: WinePairing?
		let analyzedInstructions: [AnalyzedInstruction]?
		let author, license: String?
		let spoonacularSourceURL: String?

		enum CodingKeys: String, CodingKey {
			case vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable, weightWatcherSmartPoints, gaps, lowFodmap, preparationMinutes, cookingMinutes, aggregateLikes, spoonacularScore, healthScore, creditsText, sourceName, pricePerServing, id, title, readyInMinutes, servings
			case sourceURL = "sourceUrl"
			case image, imageType, summary, cuisines, dishTypes, occasions, winePairing, analyzedInstructions, author, license
			case spoonacularSourceURL = "spoonacularSourceUrl"
		}
	}
    
    /**
     Model appears in "ExtractRecipeModel" file. Keep it here for reference of the API
     */

//	// MARK: - AnalyzedInstruction
//	struct AnalyzedInstruction: Codable {
//		let name: String?
//		let steps: [Step]?
//	}

//	// MARK: - Step
//	struct Step: Codable {
//		let number: Int?
//		let step: String?
//		let ingredients, equipment: [Ent]?
//		let length: Length?
//	}
//
//	// MARK: - Ent
//	struct Ent: Codable {
//		let id: Int?
//		let name, image: String?
//		let temperature: Length?
//	}
//
//	// MARK: - Length
//	struct Length: Codable {
//		let number: Int?
//		let unit: Unit?
//	}

	enum Unit: String, Codable {
		case celsius = "Celsius"
		case fahrenheit = "Fahrenheit"
		case minutes = "minutes"
	}

	enum Diet: String, Codable {
		case dairyFree = "dairy free"
		case fodmapFriendly = "fodmap friendly"
		case glutenFree = "gluten free"
		case ketogenic = "ketogenic"
		case lactoOvoVegetarian = "lacto ovo vegetarian"
		case paleolithic = "paleolithic"
		case pescatarian = "pescatarian"
		case primal = "primal"
	}

	enum DishType: String, Codable, CaseIterable {
		case none = "None"
		case antipasti = "antipasti"
		case antipasto = "antipasto"
		case appetizer = "appetizer"
		case batter = "batter"
		case beverage = "beverage"
		case bread = "bread"
		case breakfast = "breakfast"
		case brunch = "brunch"
		case condiment = "condiment"
		case dessert = "dessert"
		case dinner = "dinner"
		case dip = "dip"
		case drink = "drink"
		case fingerfood = "fingerfood"
		case horDOeuvre = "hor d'oeuvre"
		case lunch = "lunch"
		case mainCourse = "main course"
		case mainDish = "main dish"
		case marinade = "marinade"
		case morningMeal = "morning meal"
		case salad = "salad"
		case sauce = "sauce"
		case sideDish = "side dish"
		case snack = "snack"
		case soup = "soup"
		case spread = "spread"
		case starter = "starter"
		
		var title: String {
			return self.rawValue.capitalized
		}
	}

	enum Gaps: String, Codable {
		case gaps5 = "GAPS_5"
		case no = "no"
	}

	enum ImageType: String, Codable {
		case jpeg = "jpeg"
		case jpg = "jpg"
		case png = "png"
	}

//	// MARK: - WinePairing
//	struct WinePairing: Codable {
//		let pairedWines: [String]?
//		let pairingText: String?
//		let productMatches: [ProductMatch]?
//	}

	// MARK: - ProductMatch
	struct ProductMatch: Codable {
		let id: Int?
		let title, productMatchDescription, price: String?
		let imageURL: String?
		let averageRating: Double?
		let ratingCount: Int?
		let score: Double?
		let link: String?

		enum CodingKeys: String, CodingKey {
			case id, title
			case productMatchDescription = "description"
			case price
			case imageURL = "imageUrl"
			case averageRating, ratingCount, score, link
		}
	}

}
