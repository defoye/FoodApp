//
//  FirebaseDataManager.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/1/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import QuiteAdaptableKit
import Firebase

class FirebaseDataManager {
    static let shared = FirebaseDataManager()
    private let db = Firestore.firestore()
}

// MARK: - Writing

extension FirebaseDataManager {
    
    func addRecipeSearchData(_ recipeSearchModel: [SpoonacularAPI.RecipeComplexSearchResult]) {
        var readCount: Int = 0
        recipeSearchModel.map { model -> FirebaseAPI.TopRecipesSearchResults.ParamDict in
            return FirebaseAPI.TopRecipesSearchResults.toDict(model)
        }
        .forEach { data in
            guard let documentPath = data[.id] else {
                return
            }
            
            db.getDecodedCollectionDocument(.topRecipesSearchResults, documentPath: documentPath, FirebaseAPI.TopRecipesSearchResults.ResponseModel.self) { model in
                guard let model = model else {
                    var data = data
                    data[.hits] = String(1)
                    self.db.collection(FirebaseAPI.Collection.topRecipesSearchResults.rawValue).document(documentPath).setData(data.convertedToRawValues(), merge: true)
                    return
                }
                readCount += 1
                var modelDict = model.toDict()
                modelDict[.hits] = String(model.hits + 1)
                self.db.collection(FirebaseAPI.Collection.topRecipesSearchResults.rawValue).document(documentPath).setData(modelDict.convertedToRawValues(), merge: true)
            }
        }
    }
}

// MARK: - Retrieving

extension FirebaseDataManager {
    
    func fetchTopRecipes(numberOfResults count: Int, _ completion: @escaping ([FirebaseAPI.TopRecipesSearchResults.ResponseModel]) -> Void) {
        
        let responseModelType = FirebaseAPI.TopRecipesSearchResults.ResponseModel.self
        let collection = FirebaseAPI.Collection.topRecipesSearchResults.rawValue
        let query = db.collection(collection).order(by: "hits", descending: true).limit(to: count)
        
        query.getDecodedDocuments(responseModelType) { models in
            completion(models)
        }
    }
}
