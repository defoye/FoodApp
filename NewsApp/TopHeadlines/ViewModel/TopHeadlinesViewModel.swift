//
//  TopHeadlinesViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class TopHeadlinesViewModel {
	
	let dataManager = NewsAppDataManager()
	
	var headlines: NewsAPI.TopHeadlines?
	var items: [Item]?
	var isLoading = false
	var nextPage: Int = 1
	
	func loadTopHeadlines(_ completion: @escaping (() -> Void)) {
		isLoading = true
		completion()
		dataManager.newsApiTopHeadlines(page: nextPage) { [weak self] (status, response) in
			guard let self = self else { return }
			self.isLoading = false
			switch status {
			case .success:
				if let model = response {
					self.headlines = model
					self.createItems(model, completion)
				}
			case .error:
				break
			}
		}
	}
	
	func loadNextPage(_ completion: @escaping (() -> Void)) {
		isLoading = true
		self.nextPage += 1

		dataManager.newsApiTopHeadlines(page: nextPage) { [weak self] (status, response) in
			guard let self = self else { return }
			self.isLoading = false
			switch status {
			case .success:
				if let model = response {
					self.headlines = model
					self.createItems(model, completion)
				}
			case .error:
				break
			}
		}
	}
	
	var hasMoreContent: Bool {
		return headlines?.totalResults ?? 0 > items?.count ?? 0
	}
	
	func numberOfRows(in section: Int) -> Int {
		return isLoading ? 10 : items?.count ?? 0
	}
	
	func item(for row: Int) -> Item? {
		return items?[row]
	}
	
	func createItems(_ model: NewsAPI.TopHeadlines, _ completion: @escaping (() -> Void)) {
		guard let articles = model.articles else {
			return
		}
		var items: [Item] = []
		
		isLoading = true

		let dGroup = DispatchGroup()
		
		articles.forEach { article in
			if let url = article.urlToImage {
				dGroup.enter()
				dataManager.downloadImage(from: url) { image in
					if let image = image {
						var item = Item(article)
						item.image = image
						items.append(item)
					}
					dGroup.leave()
				}
			}
		}
		
		dGroup.notify(queue: .main) {
			self.isLoading = false
			self.items = (self.items ?? []) + items
			completion()
		}
	}
	
	func createItems(_ model: NewsAPI.TopHeadlines) {
		guard let articles = model.articles else {
			return
		}
		self.items = articles.map { article -> Item in
			return Item(article)
		}
	}
	
	func loadImage(_ imageURL: String?, _ index: Int, _ completion: @escaping ((UIImage?) -> Void)) {
		guard let url = imageURL else { return }
		dataManager.downloadImage(from: url, contentMode: .scaleAspectFit) { image in
			self.items?[index].image = image
			completion(image)
		}
	}
}

import UIKit

extension TopHeadlinesViewModel {
	struct Item {
		let source: String?
		let title: String?
		let author: String?
		let imageURL: String?
		let description: String?
		let date: String?
		let url: String?
		
		var image: UIImage?
		
		init(_ article: NewsAPI.Article) {
			self.source = article.source?.name
			self.title = article.title
			self.author = article.author
			self.imageURL = article.urlToImage
			self.description = article.articleDescription
			
			if let date = article.publishedAt?.toDate() {
				let currentDate = Date()
				self.date = currentDate.timeSinceString(date)
			} else {
				date = nil
			}
			
			self.url = article.url
		}
	}
}
