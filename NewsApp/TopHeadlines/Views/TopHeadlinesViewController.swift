//
//  TopHeadlinesViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class TopHeadlinesViewController: UIViewController, Storyboarded {

	@IBOutlet weak var tableView: UITableView!
	
	let viewModel = TopHeadlinesViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .orange
		
		title = "Top Headlines"
		
		edgesForExtendedLayout = []
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		let topHeadlinesCellNib = UINib.init(nibName: "TopHeadlinesCell", bundle: .current)
		tableView.register(topHeadlinesCellNib, forCellReuseIdentifier: "TopHeadlinesCell")
		let topHeadlinesShimmerCellNib = UINib.init(nibName: "TopHeadlinesShimmerCell", bundle: .current)
		tableView.register(topHeadlinesShimmerCellNib, forCellReuseIdentifier: "TopHeadlinesShimmerCell")
		tableView.rowHeight = UITableView.automaticDimension
		viewModel.loadTopHeadlines {
			self.reloadTableView()
		}
		
		let reloadButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadAction))
		reloadButtonItem.tintColor = .black
		navigationItem.rightBarButtonItem = reloadButtonItem
		
		if let navigationController = navigationController {
			navigationController.navigationBar.isTranslucent = false
		}
	}

	@objc
	func reloadAction() {
		nextPageCalled = false
		viewModel.nextPage = 1
		viewModel.items = nil
		viewModel.loadTopHeadlines {
			self.reloadTableView()
		}
	}
	
	var previousOffset: CGFloat = 0.0
	var nextPageCalled: Bool = false

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let contentHeight = scrollView.contentSize.height
		let frameHeight = scrollView.frame.height
		let currentY = scrollView.contentOffset.y
		let newContentScrollThreshold = contentHeight - currentY <= frameHeight * 3
		let isScrollingDown = currentY - previousOffset > 0
		let shouldLoadMoreContent = newContentScrollThreshold
									&& isScrollingDown
									&& !nextPageCalled
									&& viewModel.hasMoreContent
		
		if shouldLoadMoreContent {
			nextPageCalled = true
			viewModel.loadNextPage {
				self.reloadTableView()
				self.nextPageCalled = false
			}
		}
		
		previousOffset = currentY
	}
}

extension TopHeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = viewModel.numberOfRows(in: section)
		return numberOfRows
	}
		
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if viewModel.isLoading, let cell = tableView.dequeueReusableCell(withIdentifier: "TopHeadlinesShimmerCell", for: indexPath) as? TopHeadlinesShimmerCell {
			cell.configure()
			
			return cell
		} else if let cell = tableView.dequeueReusableCell(withIdentifier: "TopHeadlinesCell", for: indexPath) as? TopHeadlinesCell, let item = viewModel.item(for: indexPath.row) {
			
			cell.configure(item)
			if let image = item.image {
				cell.setImage(image)
			}
			
			return cell
		}
		
		return UITableViewCell()
	}
}
