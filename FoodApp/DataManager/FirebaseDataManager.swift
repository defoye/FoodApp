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
    static var currentUserUID: String? {
        Auth.auth().currentUser?.uid
    }
}

// MARK: - Writing

extension FirebaseDataManager {
    
    func addRecipeSearchData(_ recipeSearchModel: [SpoonacularAPI.RecipeComplexSearchResult]) {
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
                var modelDict = model.toDict()
                modelDict[.hits] = String((model.hits ?? 0) + 1)
                self.db.collection(FirebaseAPI.Collection.topRecipesSearchResults.rawValue).document(documentPath).setData(modelDict.convertedToRawValues(), merge: true)
            }
        }
    }
    
    func addRecipeSearchData(_ recipeSimiarModel: [SpoonacularAPI.RecipeSimilarModelElement]) {
        recipeSimiarModel.map { model -> FirebaseAPI.TopRecipesSearchResults.ParamDict in
            return FirebaseAPI.TopRecipesSearchResults.toDict(model)
        }
        .forEach { data in
            guard let documentPath = data[.id] else {
                return
            }
            
            let collection = FirebaseAPI.Collection.topRecipesSearchResults
            
            db.getDecodedCollectionDocument(collection, documentPath: documentPath, FirebaseAPI.TopRecipesSearchResults.ResponseModel.self) { model in
                guard let model = model else {
                    var data = data
                    data[.hits] = String(1)
                    self.db.collection(collection.rawValue).document(documentPath).setData(data.convertedToRawValues(), merge: true)
                    return
                }
                var modelDict = model.toDict()
                modelDict[.hits] = String((model.hits ?? 0) + 1)
                self.db.collection(collection.rawValue).document(documentPath).setData(modelDict.convertedToRawValues(), merge: true)
            }
        }
    }
    
    func addFavoriteRecipe(_ searchModel: RecipeListViewModel.Item?, similarModel: RecipeDetailViewModel.SimilarRecipeItem?, firebaseModel: FirebaseAPI.TopRecipesSearchResults.ResponseModel?, _ extractModel: SpoonacularAPI.ExtractRecipeModel, _ completion: @escaping ((Error?) -> Void)) {
        var data: [String: Any] = [:]
        var id: Int?
        if let recipeSearchModel = searchModel {
            data["responseModel"] = FirebaseAPI.TopRecipesSearchResults.toDict(recipeSearchModel).convertedToRawValues()
            id = recipeSearchModel.id
        }
        if let similarModel = similarModel {
            data["responseModel"] = FirebaseAPI.TopRecipesSearchResults.toDict(similarModel).convertedToRawValues()
            id = similarModel.id
        }
        if let firebaseModel = firebaseModel {
            data["responseModel"] = firebaseModel.toDict().convertedToRawValues()
            id = firebaseModel.id
        }
        if let extractModelDictionary = extractModel.dictionary {
            data["extractModel"] = extractModelDictionary
        }
        data["ingredients"] = extractModel.extendedIngredients?
            .map { (obj) -> RecipeDetailViewModel.IngredientItem in
                return RecipeDetailViewModel.IngredientItem(obj)
        }
            .map { item -> [String: String] in
                return item.toDict()
        }
        let collection = FirebaseAPI.Collection.users.rawValue
        if let uid = FirebaseDataManager.currentUserUID, let id = id {
            db.collection(collection).document(uid).collection("favoriteRecipes").document(String(id)).setData(data, merge: true, completion: completion)
        }
    }
    
    func removeFavoriteRecipe(_ id: Int?, _ completion: @escaping ((Error?) -> Void)) {
        let collection = FirebaseAPI.Collection.users.rawValue
        if let uid = FirebaseDataManager.currentUserUID, let id = id {
            db.collection(collection).document(uid).collection("favoriteRecipes").document(String(id)).delete(completion: completion)
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
    
    func fetchFavoriteRecipes(numberOfResults count: Int, _ completion: @escaping (([FirebaseAPI.FavoriteRecipes.ResponseModel]) -> Void)) {
        guard let uid = FirebaseDataManager.currentUserUID else {
            completion([])
            return
        }
        let ResponseModelType = FirebaseAPI.FavoriteRecipes.ResponseModel.self
        let collection = FirebaseAPI.Collection.users.rawValue
        let query = db.collection(collection).document(uid).collection("favoriteRecipes").limit(to: count)
        
        query.getDecodedDocuments(ResponseModelType) { models in
            completion(models)
        }
    }
    
    func fetchIsFavoriteRecipe(_ id: Int?, _ completion: @escaping ((_ isFavorite: Bool) -> Void)) {
        guard let uid = FirebaseDataManager.currentUserUID, let id = id else {
            completion(false)
            return
        }
        
        let ResponseModelType = FirebaseAPI.FavoriteRecipes.ResponseModel.self
        let collection = FirebaseAPI.Collection.users.rawValue
        let documentPath = String(id)
        let documentReference = db.collection(collection).document(uid).collection("favoriteRecipes").document(documentPath)
        
        documentReference.getDecodedDocument(ResponseModelType) { model in
            guard model != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
