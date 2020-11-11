//
//  SpoonacularAPI.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class SpoonacularAPI {
    
    class Extract {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case url
            case forceExtraction
            case analyze
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/extract"
        }
    }
    
    class Information {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case id
            case includeNutrition
        }
        
        static func url(_ id: String) -> String {
            "https://api.spoonacular.com/recipes/" + id + "/information"
        }
    }
    
    class InformationBulk {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case ids
            case includeNutrition
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/informationBulk"
        }
    }
    
    class ComplexSearch {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case ingredients
            case number
            case ranking
            case ignorePantry
            case offset
            case instructionsRequired
            case addRecipeInformation
            case cuisine
            case type
            case sort
            case query
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/complexSearch"
        }
    }
    
    class Similar {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case id
            case number
            case limitLicense
        }
        
        static func url(_ id: String) -> String {
            "https://api.spoonacular.com/recipes/" + id + "/similar"
        }
    }
    
    class SearchByIngredient {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case ingredients
            case number
            case ranking
            case ignorePantry
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/findByIngredients"
        }
    }
    
    class ShowImages {
        
        class Recipes {
            enum Size: String {
                case one = "90x90", two = "240x150", three = "312x150", four = "312x231", five = "480x360", size = "556x370", seven = "636x393"
            }
            
            enum ImageType: String {
                case jpg, png
            }
            
            static func createURL(_ size: Size, _ id: String, _ type: ImageType) -> String {
                return "https://spoonacular.com/recipeImages/\(id)-\(size.rawValue).\(type.rawValue)"
            }
        }
    }
	
	static var key: String {
		return "95c9f7da7d9e4d0f896eea3aa81e4a63"
	}
}

extension SpoonacularAPI {
	enum Cuisine: String, CaseIterable {
		case none = "None"
		case african = "African"
		case american = "American"
		case british = "British"
		case cajun = "Cajun"
		case caribbean = "Caribbean"
		case chinese = "Chinese"
		case easternEuropean = "Eastern European"
		case european = "European"
		case french = "French"
		case german = "German"
		case greek = "Greek"
		case indian = "Indian"
		case irish = "Irish"
		case italian = "Italian"
		case japanese = "Japanese"
		case jewish = "Jewish"
		case korean = "Korean"
		case latinAmerican = "Latin American"
		case mediterranean = "Mediterranean"
		case mexican = "Mexican"
		case middleEastern = "Middle Eastern"
		case nordic = "Nordic"
		case southern = "Southern"
		case spanish = "Spanish"
		case thai = "Thai"
		case vietnamese = "Vietnamese"
		
		var param: String {
			return self.rawValue
		}
		
		var title: String {
			return self.rawValue
		}
	}
}
