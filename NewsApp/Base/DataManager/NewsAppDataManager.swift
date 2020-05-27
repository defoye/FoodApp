//
//  NewsAppDataManager.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class NewsAppDataManager: BaseDataManager { }

// MARK:- NewsAPI

extension NewsAppDataManager {
	func newsApiTopHeadlines(page: Int, _ completion: @escaping ((RequestStatus, NewsApi.TopHeadlines?) -> Void)) {
		let endpoint = Endpoint.NewsAPI.topHeadlines
		let urlString = endpoint.url
		let params = ["country": "us", "apiKey": endpoint.key, "page": String(page)]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}
}

// MARK:- NYTimes API

extension NewsAppDataManager {
	
	func nyTimesMostPopularEmailed(_ completion: @escaping ((RequestStatus, NYTimesAPI.MostPopular?) -> Void)) {
		let urlString = Endpoint.NYTimesAPI.MostPopular.emailed.url
		let key = Endpoint.NYTimesAPI.key
		let params = ["api-key": key]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}
	
	func nyTimesMostPopularFacebook(_ completion: @escaping ((RequestStatus, NYTimesAPI.MostPopular?) -> Void)) {
		let urlString = Endpoint.NYTimesAPI.MostPopular.facebook.url
		let key = Endpoint.NYTimesAPI.key
		let params = ["api-key": key]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}

	func nyTimesMostPopularViewed(_ completion: @escaping ((RequestStatus, NYTimesAPI.MostPopular?) -> Void)) {
		let urlString = Endpoint.NYTimesAPI.MostPopular.viewed.url
		let key = Endpoint.NYTimesAPI.key
		let params = ["api-key": key]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}
}
