//
//  SpoonacularAPI+ExtractRecipeModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {
	
	// MARK: - ExtractRecipeModel
	struct ExtractRecipeModel: Codable {
		let vegetarian, vegan, glutenFree, dairyFree: Bool?
		let veryHealthy, cheap, veryPopular, sustainable: Bool?
		let weightWatcherSmartPoints: Int?
		let gaps: String?
		let lowFodmap: Bool?
		let aggregateLikes, spoonacularScore, healthScore: Int?
		let pricePerServing: Double?
		let extendedIngredients: [ExtendedIngredient]?
		let id: Int?
		let title: String?
		let servings: Int?
		let sourceURL: String?
		let image: String?
		let imageType: String?
//		let summary: JSONNull?
//		let cuisines, dishTypes, diets, occasions: [JSONAny]?
		let winePairing: WinePairing?
		let instructions: String?
		let analyzedInstructions: [AnalyzedInstruction]?
//		let sourceName, creditsText, originalID: JSONNull?
		let spoonacularSourceURL: String?

		enum CodingKeys: String, CodingKey {
			case vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable, weightWatcherSmartPoints, gaps, lowFodmap, aggregateLikes, spoonacularScore, healthScore, pricePerServing, extendedIngredients, id, title, servings
			case sourceURL = "sourceUrl"
			case image, imageType, winePairing, instructions, analyzedInstructions
			case spoonacularSourceURL = "spoonacularSourceUrl"
		}
	}

	// MARK: - AnalyzedInstruction
	struct AnalyzedInstruction: Codable {
		let name: String?
		let steps: [Step]?
	}

	// MARK: - Step
	struct Step: Codable {
		let number: Int?
		let step: String?
		let ingredients, equipment: [Ent]?
		let length: Length?
	}

	// MARK: - Ent
	struct Ent: Codable {
		let id: Int?
		let name, image: String?
		let temperature: Length?
	}

	// MARK: - Length
	struct Length: Codable {
		let number: Int?
		let unit: String?
	}

	// MARK: - ExtendedIngredient
	struct ExtendedIngredient: Codable {
		let id: Int?
		let aisle, image: String?
		let consistency: Consistency?
		let name, original, originalString, originalName: String?
		let amount: Double?
		let unit: String?
		let meta, metaInformation: [String]?
		let measures: Measures?
	}

	enum Consistency: String, Codable {
		case liquid = "liquid"
		case solid = "solid"
	}

	// MARK: - Measures
	struct Measures: Codable {
		let us, metric: Metric?
	}

	// MARK: - WinePairing
	struct WinePairing: Codable {
	}

	class JSONCodingKey: CodingKey {
		let key: String

		required init?(intValue: Int) {
			return nil
		}

		required init?(stringValue: String) {
			key = stringValue
		}

		var intValue: Int? {
			return nil
		}

		var stringValue: String {
			return key
		}
	}
}
