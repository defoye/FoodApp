//
//  SpoonacularAPI+RecipeEquipmentSearchModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI {
	
	// MARK: - RecipeEquipmentSeachModel
	struct RecipeEquipmentSeachModel: Codable {
		let equipment: [Equipment]?
	}

	// MARK: - Equipment
	struct Equipment: Codable {
		let name, image: String?
	}
}
