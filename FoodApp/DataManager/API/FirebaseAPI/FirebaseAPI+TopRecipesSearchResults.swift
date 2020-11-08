//
//  FirebaseAPI+TopRecipesSearchResults.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

extension FirebaseAPI {
    
    class TopRecipesSearchResults {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String, CaseIterable {
            case hits
            case id
            case imageURL
            case sourceURL
            case readyInMinutes
            case title
        }
        
        class ResponseItem: Hashable {
            let uuid = UUID()
            var image: UIImage?
            let responseModel: ResponseModel
            
            init(_ responseModel: ResponseModel) {
                self.responseModel = responseModel
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(uuid)
            }
            
            static func == (lhs: ResponseItem, rhs: ResponseItem) -> Bool {
                return lhs.uuid == rhs.uuid
            }
        }
        
        struct ResponseModel: Decodable {
            
            var hits: Int?
            let id: Int
            let imageURL: String
            let sourceURL: String
            let readyInMinutes: Int
            let title: String
            
            var timeTitle: String {
                "Ready in \(self.readyInMinutes.minutesIntToTimeString())"
            }
            
            private enum CodingKeys: String, CodingKey {
                case hits, id, imageURL, sourceURL, title, readyInMinutes
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                do {
                    self.hits = Int(try container.decode(String.self, forKey: .hits)) ?? 0
                } catch {
                    self.hits = nil
                }
                self.id = Int(try container.decode(String.self, forKey: .id)) ?? 0
                self.imageURL = try container.decode(String.self, forKey: .imageURL)
                self.sourceURL = try container.decode(String.self, forKey: .sourceURL)
                self.readyInMinutes = Int(try container.decode(String.self, forKey: .readyInMinutes)) ?? 0
                self.title = try container.decode(String.self, forKey: .title)
            }
                        
            func toDict() -> ParamDict {
                return Param.allCases.reduce([:]) { (dict, param) -> ParamDict in
                    var dict = dict
                    switch param {
                    case .hits: dict[param] = String(self.hits ?? 0)
                    case .id: dict[param] = String(self.id)
                    case .imageURL: dict[param] = self.imageURL
                    case .sourceURL: dict[param] = self.sourceURL
                    case .readyInMinutes: dict[param] = String(self.readyInMinutes)
                    case .title: dict[param] = self.title
                    }
                    
                    return dict
                }
            }
        }
        
        let collection = Collection.topRecipesSearchResults.rawValue
        
        /**
         Function to convert model to Dictionary with selected data.
         
         Currently used to upload model to Firestore with limited parameters. Possibily in the future we will just upload the entire model.
         The current dictionary being created can be used to represent a `RecipeListCell` on the search results page.
         */
        static func toDict(_ model: SpoonacularAPI.RecipeComplexSearchResult) -> ParamDict {
            var dict: ParamDict = [:]
            
            dict[.title] = model.title
            if let readyInMinutes = model.readyInMinutes {
                dict[.readyInMinutes] = String(readyInMinutes)
            }
            if let sourceURL = model.sourceURL {
                dict[.sourceURL] = sourceURL
            }
            if let id = model.id {
                dict[.id] = String(id)
            }
            dict[.imageURL] = model.image
            
            return dict
        }
        
        static func toDict(_ model: RecipeListViewModel.Item) -> ParamDict {
            var dict: ParamDict = [:]
            
            dict[.title] = model.title
            if let readyInMinutes = model.readyInMinutes {
                dict[.readyInMinutes] = String(readyInMinutes)
            }
            if let sourceURL = model.sourceURL {
                dict[.sourceURL] = sourceURL
            }
            if let id = model.id {
                dict[.id] = String(id)
            }
            dict[.imageURL] = model.imageURL
            
            return dict
        }
        
        static func toDict(_ model: SpoonacularAPI.RecipeSimilarModelElement) -> ParamDict {            
            let similarModel = RecipeDetailViewModel.SimilarRecipeItem(model, image: nil)
            
            return toDict(similarModel)
        }
        
        static func toDict(_ model: RecipeDetailViewModel.SimilarRecipeItem) -> ParamDict {
            var dict: ParamDict = [:]
                        
            dict[.title] = model.title
            if let readyInMinutes = model.readyInMinutes {
                dict[.readyInMinutes] = String(readyInMinutes)
            }
            if let sourceURL = model.sourceURL {
                dict[.sourceURL] = sourceURL
            }
            if let id = model.id {
                dict[.id] = String(id)
            }
            dict[.imageURL] = model.imageURL
            
            return dict
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/extract"
        }
    }
}
