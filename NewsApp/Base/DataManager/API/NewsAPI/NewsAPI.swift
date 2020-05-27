//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum NewsAPI {
	case topHeadlines
	
	var url: String {
		switch self {
		case .topHeadlines:
			return "https://newsapi.org/v2/top-headlines"
		}
	}
	
	var key: String {
		return "9b3d07f6d7a64e79bac458c38808f129"
	}
}
