//
//  ViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class ViewModel {
	
	let dataManager = DataManager()
	
	var headlines: NewsApi.TopHeadlines?
	
	func loadTopHeadlines(_ completion: @escaping (() -> Void)) {
		dataManager.newsApiTopHeadlines { [weak self] (status, response) in
			guard let self = self else { return }
			switch status {
			case .success:
				if let model = response {
					self.headlines = model
					completion()
				}
			case .error:
				break
			}
		}
	}
	
	func numberOfRows(in section: Int) -> Int {
		return headlines?.articles?.count ?? 0
	}
	
	func item(for row: Int) -> NewsApi.Article? {
		return headlines?.articles?[row]
	}
}

extension ViewModel {
	struct Item {
		let source: String?
		let title: String?
		let author: String?
		let imageURL: String?
		let description: String?
		let date: String?
		
		init(_ article: NewsApi.Article) {
			self.source = article.source?.name
			self.title = article.title
			self.author = article.author
			self.imageURL = article.urlToImage
			self.description = article.articleDescription
			self.date = article.publishedAt
		}
	}
}
