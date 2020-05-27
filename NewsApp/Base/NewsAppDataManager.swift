//
//  NewsAppDataManager.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

enum Endpoint: String {
	case theGuardianEditions = "https://content.guardianapis.com/editions"
	case newsAPITopHeadlines = "https://newsapi.org/v2/top-headlines"
	case nyTimesMostPopularEmailed = "https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json"
	case nyTimesMostPopularFacebook = "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json"
	case nyTimesMostPopularViewed = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"

	var key: String {
		switch self {
		case .theGuardianEditions:
			return "2ddfc191-3af8-464f-971f-f1074c468cd7"
		case .newsAPITopHeadlines:
			return "9b3d07f6d7a64e79bac458c38808f129"
		case .nyTimesMostPopularEmailed:
			return "8GBUsQA5f3a7KHuefWlwQNcQ1c4cYBTp"
		case .nyTimesMostPopularFacebook:
			return "8GBUsQA5f3a7KHuefWlwQNcQ1c4cYBTp"
		case .nyTimesMostPopularViewed:
			return "8GBUsQA5f3a7KHuefWlwQNcQ1c4cYBTp"
		}
	}
}

enum EndpointType {
	enum theGuardianAPI: String {
		case editions = "https://content.guardianapis.com/editions"
	}
	enum newsAPI: String {
		case topHeadlines = "https://newsapi.org/v2/top-headlines"
	}
	enum nyTimesAPI {
		enum MostPopular: String {
			case emailed = "https://api.nytimes.com/svc/mostpopular/v2/emailed/7.json"
			case facebook = "https://api.nytimes.com/svc/mostpopular/v2/shared/1/facebook.json"
			case nyTimesMostPopularViewed = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json"
		}
		
		var key: String {
			return "8GBUsQA5f3a7KHuefWlwQNcQ1c4cYBTp"
		}
	}
}

enum RequestStatus {
	case success
	case error
}

class BaseDataManager {
	public func dataTask<T : Decodable>(_ url: URL, _ completion: @escaping ((RequestStatus, T?) -> Void)) {
		print("----------------------------------REQUEST START----------------------------------")
		URLSession.shared.dataTask(with: url) { (data, reponse, error) in
			if let _ = error {
				completion(.error, nil)
			}
			
			if let data = data {
				do {
					let decoded = try JSONDecoder().decode(T.self, from: data)
					completion(.success, decoded)
				} catch _ {

				}
			}
			
			completion(.error, nil)
		}.resume()
		print("----------------------------------REQUEST END------------------------------------")
	}
	
	public func dataTask<T : Decodable>(_ request: URLRequest, _ completion: @escaping ((RequestStatus, T?) -> Void)) {
		print("----------------------------------REQUEST START----------------------------------")
		URLSession.shared.dataTask(with: request) { (data, reponse, error) in
			if let _ = error {
				completion(.error, nil)
			}
			
			if let data = data {
				do {
					let decoded = try JSONDecoder().decode(T.self, from: data)
					completion(.success, decoded)
				} catch let err {
					print(err)
				}
			}
			
			completion(.error, nil)
		}.resume()
		print("----------------------------------REQUEST END------------------------------------")
	}
	
	func downloadImage(_ url: URL, contentMode: UIView.ContentMode, _ completion: @escaping ((UIImage?) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
					completion(nil)
					return
			}
			completion(image)
        }.resume()
	}
	
	func downloadImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, _ completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: link) else {
			completion(nil)
			return
		}
		
		downloadImage(url, contentMode: mode, completion)
		
    }
	
	func createRequest(_ urlString: String, _ parameters: [String: String]?, _ headers: [String: String]?) -> URLRequest {
		var urlComponents = URLComponents(string: urlString)

		var queryItems = [URLQueryItem]()
		
		if let parameters = parameters {
			for (key, value) in parameters {
				queryItems.append(URLQueryItem(name: key, value: value))
			}
		}

		urlComponents?.queryItems = queryItems

		var request = URLRequest(url: (urlComponents?.url)!)
		request.httpMethod = "GET"

		if let headers = headers {
			for (key, value) in headers {
				request.setValue(value, forHTTPHeaderField: key)
			}
		}
		
		return request
	}
}

class NewsAppDataManager: BaseDataManager {
	
}

// MARK:- NewsAPI

extension NewsAppDataManager {
	func newsApiTopHeadlines(page: Int, _ completion: @escaping ((RequestStatus, NewsApi.TopHeadlines?) -> Void)) {
		let urlString = Endpoint.newsAPITopHeadlines.rawValue
		let params = ["country": "us", "apiKey": Endpoint.newsAPITopHeadlines.key, "page": String(page)]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}
}

// MARK:- NYTimes API

extension NewsAppDataManager {
	
	func nyTimesMostPopularEmailed(_ completion: @escaping ((RequestStatus, NYTimesAPI.MostPopular?) -> Void)) {
		let urlString = Endpoint.nyTimesMostPopularEmailed.rawValue
		let params = ["api-key": Endpoint.nyTimesMostPopularEmailed.key]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}
	
	func nyTimesMostPopularFacebook(_ completion: @escaping ((RequestStatus, NYTimesAPI.MostPopular?) -> Void)) {
		let urlString = Endpoint.nyTimesMostPopularFacebook.rawValue
		let params = ["api-key": Endpoint.nyTimesMostPopularFacebook.key]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}

	func nyTimesMostPopularViewed(_ completion: @escaping ((RequestStatus, NYTimesAPI.MostPopular?) -> Void)) {
		let urlString = Endpoint.nyTimesMostPopularViewed.rawValue
		let params = ["api-key": Endpoint.nyTimesMostPopularViewed.key]

		let request = createRequest(urlString, params, nil)
		
		dataTask(request, completion)
	}
}
