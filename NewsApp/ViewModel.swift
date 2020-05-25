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
	var items: [Item]?
	
	func loadTopHeadlines(_ completion: @escaping (() -> Void)) {
		dataManager.newsApiTopHeadlines { [weak self] (status, response) in
			guard let self = self else { return }
			switch status {
			case .success:
				if let model = response {
					self.headlines = model
					self.createItems(model)
					completion()
				}
			case .error:
				break
			}
		}
	}
	
	func numberOfRows(in section: Int) -> Int {
		return items?.count ?? 0
	}
	
	func item(for row: Int) -> Item? {
		return items?[row]
	}
	
	func createItems(_ model: NewsApi.TopHeadlines) {
		self.items = model.articles?.map { article -> Item in
			return Item(article)
		}
	}
	
	func loadImage(_ imageURL: String?, _ index: Int, _ completion: @escaping ((UIImage) -> Void)) {
		guard let url = imageURL else { return }
		dataManager.downloadImage(from: url, contentMode: .scaleAspectFit) { image in
			self.items?[index].image = image
			completion(image)
		}
	}
}

import UIKit

extension ViewModel {
	struct Item {
		let source: String?
		let title: String?
		let author: String?
		let imageURL: String?
		let description: String?
		let date: String?
		
		var image: UIImage?
		
		init(_ article: NewsApi.Article) {
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
		}
	}
}

extension Date {
	
	func timeSinceString(_ date: Date) -> String? {
		let interval = self - date
		
		let days = Int(interval / 86400)
		let hours = Int(interval.truncatingRemainder(dividingBy: 86400)) / 3600
		let minutes = Int(interval.truncatingRemainder(dividingBy: 3600)) / 60
		let seconds = Int((interval.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
		
		if days > 0 {
			return "\(days)d ago"
		} else if hours > 0 {
			return "\(hours)h ago"
		} else if minutes > 0 {
			return "\(minutes)m ago"
		} else if seconds > 0 {
			return "\(seconds)s ago"
		} else {
			return nil
		}
	}

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension String {
	func toDate() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		guard let currentDate = dateFormatter.date(from: self) else {
			return nil
		}
		return currentDate
	}
	
	func formattedDateString() -> String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy"
		if let date = self.toDate() {
			return dateFormatter.string(from: date)
		} else {
			return nil
		}
	}
}
