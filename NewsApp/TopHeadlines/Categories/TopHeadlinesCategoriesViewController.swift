//
//  TopHeadlinesCategoriesViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class TopHeadlinesCategoriesViewController: UIViewController, Storyboarded {
	
	@IBOutlet weak var tableView: UITableView!
	
	let viewModel = TopHeadlinesCategoriesViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "newspaper"), selectedImage: nil)
		navigationItem.title = "Tsatsa's News Categories"
//		title = "News"
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		tableView.separatorStyle = .none
		let categoryCellNib = UINib.init(nibName: "CategoryCell", bundle: .current)
		tableView.register(categoryCellNib, forCellReuseIdentifier: "CategoryCell")
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
	}
}

extension TopHeadlinesCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(in: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
			fatalError()
		}
		
		cell.configure(viewModel.item(for: indexPath.row))
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let categoryParam = viewModel.item(for: indexPath.row).param
				
		let viewModel = TopHeadlinesViewModel(categoryParam)
		let viewController = TopHeadlinesViewController.instantiate("TopHeadlines")
		viewController.initViewModel(viewModel)
		
		navigationController?.pushViewController(viewController, animated: true)
	}
}
