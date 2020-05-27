//
//  Endpoint.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum Endpoint {
	
	enum TheGuardianAPI {
		case editions
		
		var url: String {
			switch self {
			case .editions:
				return "https://content.guardianapis.com/editions"
			}
		}
		
		var key: String {
			return "2ddfc191-3af8-464f-971f-f1074c468cd7"
		}
	}
	
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
	
	enum NYTimesAPI {
		enum MostPopular: String {
			case emailed
			case facebook
			case viewed
			
			var url: String {
				switch self {
				case .emailed:
					return "https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json"
				case .facebook:
					return "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json"
				case .viewed:
					return "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"
				}
			}
		}
		
		static var key: String {
			return "8GBUsQA5f3a7KHuefWlwQNcQ1c4cYBTp"
		}
	}
}
