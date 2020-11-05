//
//  SpoonacularAPI+RecipeSimilarModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {

	// MARK: - RecipeSimilarModelElement
	struct RecipeSimilarModelElement: Codable {
		let id: Int?
		let imageType: ImageType?
		let title: String?
		let readyInMinutes, servings: Int?
		let sourceURL: String?

		enum CodingKeys: String, CodingKey {
			case id, imageType, title, readyInMinutes, servings
			case sourceURL = "sourceUrl"
		}
	}

//	enum ImageType: String, Codable {
//		case jpg = "jpg"
//	}

	typealias RecipeSimilarModel = [RecipeSimilarModelElement]

}
