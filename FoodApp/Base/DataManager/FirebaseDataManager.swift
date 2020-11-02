//
//  FirebaseDataManager.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/1/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import QuiteAdaptableKit
import Firebase

enum FirebaseCollection: String {
    case topRecipesSearchResults
}

class FirebaseDataManager {
    static let shared = FirebaseDataManager()
    private let db = Firestore.firestore()
    
    func addRecipeSearchData(_ recipeSearchModel: [SpoonacularAPI.RecipeComplexSearchResult]) {
        
        recipeSearchModel.map { result -> [String: Any] in
            return result.toDict()
        }
        .forEach { data in
            guard let id = data["id"] as? Int else {
                return
            }
            let documentPath = String(id)
            
            db.collection(FirebaseCollection.topRecipesSearchResults.rawValue).getDocument(documentPath) { (documentSnapshot) in
                var data = data
                var hits: Int = 1
                guard let snapshotData = documentSnapshot?.data() else {
                    data["hits"] = hits
                    self.db.collection(FirebaseCollection.topRecipesSearchResults.rawValue).document(documentPath).setData(data, merge: true)
                    return
                }
                if let dataHits = snapshotData["hits"] as? Int {
                    hits = dataHits + 1
                }
                data["hits"] = hits
                self.db.collection(FirebaseCollection.topRecipesSearchResults.rawValue).document(documentPath).setData(data, merge: true)
            }
        }
            
    }
}
