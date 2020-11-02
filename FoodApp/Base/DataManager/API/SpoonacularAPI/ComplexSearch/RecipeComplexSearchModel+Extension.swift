//
//  RecipeComplexSearchModel+Extension.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/1/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension SpoonacularAPI.RecipeComplexSearchResult {
    
    /**
     Function to convert model to Dictionary with selected data.
     
     Currently used to upload model to Firestore with limited parameters. Possibily in the future we will just upload the entire model.
     The current dictionary being created can be used to represent a `RecipeListCell` on the search results page.
     */
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["title"] = title
        dict["timeTitle"] = self.readyInMinutes
        dict["sourceURL"] = sourceURL
        dict["id"] = id
        dict["image"] = image
        
        return dict
    }
}
