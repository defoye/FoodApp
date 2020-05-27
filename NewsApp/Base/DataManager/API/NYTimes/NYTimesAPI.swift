//
//  NYTimesAPI.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

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
