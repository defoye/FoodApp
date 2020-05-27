//
//  TopHeadlinesCategoriesViewModel.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

class TopHeadlinesCategoriesViewModel {
	
	let dataManager = NewsAppDataManager()
	let items: [Item]
	
	init() {
		items = ["all", "business", "entertainment", "general", "health", "science", "sports", "technology"].map { category -> Item in
			let title = category.lowercased().capitalized
			return Item(title: title, param: category == "all" ? "" : category)
		}
	}
	
	
	func numberOfRows(in section: Int) -> Int {
		return items.count
	}
	
	func item(for row: Int) -> Item {
		return items[row]
	}
}

extension TopHeadlinesCategoriesViewModel {
	struct Item {
		let title: String
		let param: String
	}
}
