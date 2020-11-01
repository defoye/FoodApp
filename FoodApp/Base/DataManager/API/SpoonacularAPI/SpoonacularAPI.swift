//
//  SpoonacularAPI.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum SpoonacularAPI {
    
    enum Extract {
        
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
    
    enum Information {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case id
            case includeNutrition
        }
        
        static func url(_ id: String) -> String {
            "https://api.spoonacular.com/recipes/" + id + "/information"
        }
    }
    
    enum InformationBulk {
        
        typealias ParamDict = [Param: String]
        
        enum Param: String {
            case ids
            case includeNutrition
        }
        
        static var url: String {
            return "https://api.spoonacular.com/recipes/informationBulk"
        }
    }
    
    enum ComplexSearch {
        
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
    
    enum Similar {
        
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
    
    enum SearchByIngredient {
        
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
