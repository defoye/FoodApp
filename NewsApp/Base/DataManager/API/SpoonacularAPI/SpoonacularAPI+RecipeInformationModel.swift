//
//  SpoonacularAPI+RecipeInformationModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {

	// MARK: - RecipeInformationModel
	struct RecipeInformationModel: Codable {
		let vegetarian, vegan, glutenFree, dairyFree: Bool?
		let veryHealthy, cheap, veryPopular, sustainable: Bool?
		let weightWatcherSmartPoints: Int?
		let gaps: String?
		let lowFodmap: Bool?
		let aggregateLikes, spoonacularScore, healthScore: Int?
		let creditsText, license, sourceName: String?
		let pricePerServing: Double?
		let extendedIngredients: [ExtendedIngredient]?
		let id: Int?
		let title: String?
		let readyInMinutes, servings: Int?
		let sourceURL: String?
		let image: String?
		let imageType, summary: String?
//		let cuisines: [JSONAny]?
		let dishTypes: [String]?
//		let diets, occasions: [JSONAny]?
		let winePairing: WinePairing?
		let instructions: String?
		let analyzedInstructions: [AnalyzedInstruction]?
//		let originalID: JSONNull?
		let spoonacularSourceURL: String?

		enum CodingKeys: String, CodingKey {
			case vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable, weightWatcherSmartPoints, gaps, lowFodmap, aggregateLikes, spoonacularScore, healthScore, creditsText, license, sourceName, pricePerServing, extendedIngredients, id, title, readyInMinutes, servings
			case sourceURL = "sourceUrl"
			case image, imageType, summary, dishTypes, winePairing, instructions, analyzedInstructions
			case spoonacularSourceURL = "spoonacularSourceUrl"
		}
	}

//	// MARK: - ExtendedIngredient
//	struct ExtendedIngredient: Codable {
//		let id: Int?
//		let aisle, image: String?
//		let consistency: Consistency?
//		let name, original, originalString, originalName: String?
//		let amount: Double?
//		let unit: String?
//		let meta, metaInformation: [String]?
//		let measures: Measures?
//	}

//	enum Consistency: String, Codable {
//		case liquid = "liquid"
//		case solid = "solid"
//	}

//	// MARK: - Measures
//	struct Measures: Codable {
//		let us, metric: Metric?
//	}

//	// MARK: - Metric
//	struct Metric: Codable {
//		let amount: Double?
//		let unitShort, unitLong: String?
//	}

//	// MARK: - WinePairing
//	struct WinePairing: Codable {
//		let pairedWines: [JSONAny]?
//		let pairingText: String?
//		let productMatches: [JSONAny]?
//	}
}
