//
//  NewsAPI+TopHeadlines.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

extension NewsAPI {
	// MARK: - TopHeadlines
	struct TopHeadlines: Codable {
		let status: String?
		let totalResults: Int?
		let articles: [Article]?
	}

	// MARK: - Article
	struct Article: Codable {
		let source: Source?
		let author: String?
		let title, articleDescription: String?
		let url: String?
		let urlToImage: String?
		let publishedAt: String?
		let content: String?

		enum CodingKeys: String, CodingKey {
			case source, author, title
			case articleDescription = "description"
			case url, urlToImage, publishedAt, content
		}
	}

	// MARK: - Source
	struct Source: Codable {
		let id: String?
		let name: String?
	}
}
