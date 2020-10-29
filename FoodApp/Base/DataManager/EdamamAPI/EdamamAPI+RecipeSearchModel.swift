//
//  EdamamAPI+RecipeSearchModel.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension EdamamAPI {
    
    // MARK: - RecipeSearchModel
    struct RecipeSearchModel: Codable {
        let q: String?
        let from, to: Int?
        let more: Bool?
        let count: Int?
        let hits: [Hit]?
    }

    // MARK: - Hit
    struct Hit: Codable {
        let recipe: Recipe?
        let bookmarked, bought: Bool?
    }

    // MARK: - Recipe
    struct Recipe: Codable {
        let uri: String?
        let label: String?
        let image: String?
        let source: String?
        let url: String?
        let shareAs: String?
        let yield: Int?
        let dietLabels, healthLabels, cautions, ingredientLines: [String]?
        let ingredients: [Ingredient]?
        let calories, totalWeight: Double?
        let totalTime: Int?
        let totalNutrients, totalDaily: [String: Total]?
        let digest: [Digest]?
    }

    // MARK: - Digest
    struct Digest: Codable {
        let label, tag: String?
        let schemaOrgTag: String?
        let total: Double?
        let hasRDI: Bool?
        let daily: Double?
        let unit: Unit?
        let sub: [Digest]?
    }

    enum Unit: String, Codable {
        case empty = "%"
        case g = "g"
        case kcal = "kcal"
        case mg = "mg"
        case µg = "µg"
    }

    // MARK: - Ingredient
    struct Ingredient: Codable {
        let text: String?
        let weight: Double?
        let image: String?
    }

    // MARK: - Total
    struct Total: Codable {
        let label: String?
        let quantity: Double?
        let unit: Unit?
    }
}
