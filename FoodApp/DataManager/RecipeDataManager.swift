//
//  RecipeDataManager.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import QuiteAdaptableKit

class RecipeDataManager: BaseDataManager {
    
    static let shared = RecipeDataManager()
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
	
    func extractRecipeSearch(_ params: SpoonacularAPI.Extract.ParamDict, _ completion: @escaping ((RequestStatus, SpoonacularAPI.ExtractRecipeModel?) -> Void)) {
        let urlString = SpoonacularAPI.Extract.url
		let key = SpoonacularAPI.key
        let combinedParams = ["apiKey": key].merged(with: params.convertedToRawValues())
		let request = createRequest(urlString, combinedParams, nil)
		
        if useOnlineData {
            dataTask(request, completion)
        } else {
            offlineRequest("SpoonacularExtractRecipeResponse_RoastedVeggiePasta", forType: SpoonacularAPI.ExtractRecipeModel.self, completion)
        }
	}
	
    func recipeInformationSearch(_ params: SpoonacularAPI.Information.ParamDict, _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeInformationModel?) -> Void)) {
        guard let id = params[.id] else {
			fatalError()
		}
        let urlString = SpoonacularAPI.Information.url(id)
		let key = SpoonacularAPI.key
        let combinedParams = ["apiKey": key].merged(with: params.convertedToRawValues())
		let request = createRequest(urlString, combinedParams, nil)
		
		dataTask(request, completion)
	}
	
    func recipeComplexSearch(_ params: SpoonacularAPI.ComplexSearch.ParamDict, _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeComplexSearchModel?) -> Void)) {
        let urlString = SpoonacularAPI.ComplexSearch.url
		let key = SpoonacularAPI.key
        let combinedParams = ["apiKey": key].merged(with: params.convertedToRawValues())
		let request = createRequest(urlString, combinedParams, nil)
		
        if useOnlineData {
            dataTask(request, completion)
        } else {
            offlineRequest("SpoonacularComplexSearchResponse1", forType: SpoonacularAPI.RecipeComplexSearchModel.self, completion)
        }
	}
	
    func recipeSimilarSearch(_ params: SpoonacularAPI.Similar.ParamDict, _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeSimilarModel?) -> Void)) {
        guard let id = params[.id] else {
			fatalError()
		}
        let urlString = SpoonacularAPI.Similar.url(id)
		let key = SpoonacularAPI.key
        let combinedParams = ["apiKey": key].merged(with: params.convertedToRawValues())
		let request = createRequest(urlString, combinedParams, nil)
		
		dataTask(request, completion)
	}
    
    func recipeSearchByIngredients(_ params: SpoonacularAPI.SearchByIngredient.ParamDict, _ completion: @escaping ((RequestStatus, SpoonacularAPI.RecipeSimilarModel?) -> Void)) {
        let urlString = SpoonacularAPI.SearchByIngredient.url
        let key = SpoonacularAPI.key
        let combinedParams = ["apiKey": key].merged(with: params.convertedToRawValues())
        let request = createRequest(urlString, combinedParams, nil)
        
        dataTask(request, completion)
    }
}
