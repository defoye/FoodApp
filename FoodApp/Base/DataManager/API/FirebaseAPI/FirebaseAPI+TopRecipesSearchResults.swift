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
            case image
            case sourceURL
            case readyInMinutes
            case title
        }
        
        class ResponseModel: Decodable, Hashable {
            
            let uuid = UUID()
            let hits: Int
            let id: Int
            let imageURL: String
            let sourceURL: String
            let readyInMinutes: Int
            let title: String
            let timeTitle: String
            
            var image: UIImage?
            
            private enum CodingKeys: String, CodingKey {
                case hits, id, image, sourceURL, timeTitle, title
            }
            
            required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.hits = Int(try container.decode(String.self, forKey: .hits)) ?? 0
                self.id = Int(try container.decode(String.self, forKey: .id)) ?? 0
                self.imageURL = try container.decode(String.self, forKey: .image)
                self.sourceURL = try container.decode(String.self, forKey: .sourceURL)
                self.readyInMinutes = Int(try container.decode(String.self, forKey: .timeTitle)) ?? 0
                self.title = try container.decode(String.self, forKey: .title)
                self.timeTitle = "Ready in \(self.readyInMinutes.minutesIntToTimeString())"
            }
            
            func toDict() -> ParamDict {
                return Param.allCases.reduce([:]) { (dict, param) -> ParamDict in
                    var dict = dict
                    switch param {
                    case .hits: dict[param] = String(self.hits)
                    case .id: dict[param] = String(self.id)
                    case .image: dict[param] = self.imageURL
                    case .sourceURL: dict[param] = self.sourceURL
                    case .readyInMinutes: dict[param] = String(self.readyInMinutes)
                    case .title: dict[param] = self.title
                    }
                    
                    return dict
                }
            }
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(uuid)
            }
            
            static func == (lhs: ResponseModel, rhs: ResponseModel) -> Bool {
                return lhs.uuid == rhs.uuid
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
            dict[.image] = model.image
            
            return dict
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/extract"
        }
    }
}
