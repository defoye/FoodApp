//
//  SpoonacularAPI.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum SpoonacularAPI {
	enum Recipes {
		case search
		case extract
		case information
		case informationBulk
		case complexSearch
		
		var url: String {
			switch self {
			case .search:
				return "https://api.spoonacular.com/recipes/search"
			case .extract:
				return "https://api.spoonacular.com/recipes/extract"
			case .information:
				return "https://api.spoonacular.com/recipes/"
			case .informationBulk:
				return "https://api.spoonacular.com/recipes/informationBulk"
			case .complexSearch:
				return "https://api.spoonacular.com/recipes/complexSearch"
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
