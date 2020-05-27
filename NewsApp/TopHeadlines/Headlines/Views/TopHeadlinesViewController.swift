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
	
	var viewModel: TopHeadlinesViewModel!
	
	func initViewModel(_ viewModel: TopHeadlinesViewModel) {
		self.viewModel = viewModel
	}
	
	func configureRefreshControl() {
		tableView.refreshControl = UIRefreshControl()
	    tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
	}
		
	@objc func handleRefreshControl() {
		nextPageCalled = false
		viewModel.nextPage = 1
		viewModel.items = nil
		viewModel.loadTopHeadlines {
			DispatchQueue.main.async {
				self.tableView.refreshControl?.endRefreshing()
			}
			self.reloadTableView()
		}
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .orange
		
		title = "\u{1F618} Tsatsa's Top Headlines \u{1F618}"
		
		configureRefreshControl()
		
		edgesForExtendedLayout = []
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
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
		
		if let navigationController = navigationController {
			navigationController.navigationBar.isTranslucent = false
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let item = viewModel.item(for: indexPath.row),
			  let urlString = item.url,
			  let url = URL(string: urlString),
			  let cell = tableView.cellForRow(at: indexPath),
			  cell is TopHeadlinesCell
			else {
				return
		}
		
		UIApplication.shared.open(url)
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
