//
//  SpoonacularAPI+RecipeSearchComplexModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {

	// MARK: - RecipeSearchComplexModel
	struct RecipeSearchComplexModel: Codable {
		let results: [Result]?
		let offset, number, totalResults: Int?
	}

	// MARK: - Nutrition
	struct Nutrition: Codable {
		let title: String?
		let amount: Double?
		let unit: String?
	}
}
