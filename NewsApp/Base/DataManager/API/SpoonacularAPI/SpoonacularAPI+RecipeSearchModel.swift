//
//  SpoonacularAPI+RecipeSearchModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {
	// MARK: - RecipeSearchModel
	struct RecipeSearchModel: Codable {
		let results: [Result]?
		let baseURI: String?
		let offset, number, totalResults, processingTimeMS: Int?
		let expires: Int?
		let isStale: Bool?

		enum CodingKeys: String, CodingKey {
			case results
			case baseURI = "baseUri"
			case offset, number, totalResults
			case processingTimeMS = "processingTimeMs"
			case expires, isStale
		}
	}

	// MARK: - Result
	struct Result: Codable {
		let id: Int?
		let title: String?
		let readyInMinutes, servings: Int?
		let sourceURL: String?
		let openLicense: Int?
		let image: String?

		enum CodingKeys: String, CodingKey {
			case id, title, readyInMinutes, servings
			case sourceURL = "sourceUrl"
			case openLicense, image
		}
	}
}
