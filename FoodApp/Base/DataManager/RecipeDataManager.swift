//
//  RecipeDataManager.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDataManager: BaseDataManager {
    
    let useOnlineData: Bool = false
    
    fileprivate func offlineRequest<T: Decodable>(_ fileName: String, forType type: T.Type, _ completion: @escaping ((RequestStatus, T?) -> Void)) {
        guard let decodedData = decodedJSONData(from: fileName, forType: T.self) else {
            completion(.error, nil)
            return
        }
        
        completion(.success, decodedData)
    }
}

extension RecipeDataManager {
	
	func extractRecipeSearch(_ params: [String: String], _ completion: @escaping ((RequestStatus, SpoonacularAPI.ExtractRecipeModel?) -> Void)) {
		let urlString = SpoonacularAPI.Recipes.extract.url
		let key = SpoonacularAPI.key
		let combinedParams = ["apiKey": key].merged(with: params)
		let request = createRequest(urlString, combinedParams, nil)
		
		dataTask(request, completion)
	}
	
	func recipeInformationSearch(_ params: [String: String], _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeInformationModel?) -> Void)) {
		guard let id = params["id"] else {
			fatalError()
		}
		let urlString = SpoonacularAPI.Recipes.search.url + "\(id)/information"
		let key = SpoonacularAPI.key
		let combinedParams = ["apiKey": key].merged(with: params)
		let request = createRequest(urlString, combinedParams, nil)
		
		dataTask(request, completion)
	}
	
	func recipeComplexSearch(_ params: [String: String], _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeComplexSearchModel?) -> Void)) {
		let urlString = SpoonacularAPI.Recipes.complexSearch.url
		let key = SpoonacularAPI.key
		let combinedParams = ["apiKey": key].merged(with: params)
		let request = createRequest(urlString, combinedParams, nil)
		
        if useOnlineData {
            dataTask(request, completion)
        } else {
            offlineRequest("SpoonacularComplexSearchResponse1", forType: SpoonacularAPI.RecipeComplexSearchModel.self, completion)
        }
	}
	
	func recipeSimilarSearch(_ params: [String: String], _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeSimilarModel?) -> Void)) {
		guard let id = params["id"] else {
			fatalError()
		}
		let urlString = SpoonacularAPI.Recipes.similar.url + "\(id)/similar"
		let key = SpoonacularAPI.key
		let combinedParams = ["apiKey": key].merged(with: params)
		let request = createRequest(urlString, combinedParams, nil)
		
		dataTask(request, completion)
	}
}
