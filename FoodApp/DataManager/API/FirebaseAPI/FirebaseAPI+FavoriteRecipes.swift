//
//  FirebaseAPI+FavoriteRecipes.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/3/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension FirebaseAPI {
    
    class FavoriteRecipes {
        
        typealias ParamDict = [Param: String]
        typealias IngredientItem = RecipeDetailViewModel.IngredientItem
        
        enum Param: String, CaseIterable {
            case id
            case image
            case sourceURL
            case readyInMinutes
            case title
            case ingredients
            case extractModel
        }
        
        struct ResponseModel: Decodable {
            let extractModel: SpoonacularAPI.ExtractRecipeModel?
            let responseModel: FirebaseAPI.TopRecipesSearchResults.ResponseModel?
        }
        
        static func toDict(_ searchModel: SpoonacularAPI.RecipeComplexSearchResult?, _ extractModel: SpoonacularAPI.ExtractRecipeModel) -> ParamDict {
            if let searchModel = searchModel {
                
            }
            
            return [:]
        }
        
        private static func toSearchDict(_ searchModel: SpoonacularAPI.RecipeComplexSearchResult) -> ParamDict {
            var dict: ParamDict = [:]
            
            dict[.title] = searchModel.title
            if let readyInMinutes = searchModel.readyInMinutes {
                dict[.readyInMinutes] = String(readyInMinutes)
            }
            if let sourceURL = searchModel.sourceURL {
                dict[.sourceURL] = sourceURL
            }
            if let id = searchModel.id {
                dict[.id] = String(id)
            }
            dict[.image] = searchModel.image
            
            return dict
        }
    }
}
