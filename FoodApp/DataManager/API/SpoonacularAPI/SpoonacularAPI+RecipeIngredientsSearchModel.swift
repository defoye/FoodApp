//
//  SpoonacularAPI+RecipeIngredientsSearchModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {

	// MARK: - RecipeIngredientsSeachModel
	struct RecipeIngredientsSeachModel: Codable {
		let ingredients: [Ingredient]?
	}

	// MARK: - Ingredient
	struct Ingredient: Codable {
		let name, image: String?
		let amount: Amount?
	}

	// MARK: - Amount
	struct Amount: Codable {
		let metric, us: Metric?
	}

	// MARK: - Metric
	struct Metric: Codable {
		let value: Double?
		let unit: String?
	}
}
