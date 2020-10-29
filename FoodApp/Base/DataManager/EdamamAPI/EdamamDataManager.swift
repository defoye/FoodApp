//
//  EdamamDataManager.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class EdamamDataManager: BaseDataManager {
    
    func recipeSearch(_ params: [String: String], _ completion: @escaping ((RequestStatus, EdamamAPI.RecipeSearchModel?) -> Void)) {
        let urlString = EdamamAPI.Recipes.search.url
        let key = EdamamAPI.key
        let combinedParams = ["apiKey": key].merged(with: params)
        let request = createRequest(urlString, combinedParams, nil)
        
        dataTask(request, completion)
    }
}
