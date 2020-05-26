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
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		let nib = UINib.init(nibName: "TopHeadlinesCell", bundle: .current)
		tableView.register(nib, forCellReuseIdentifier: "TopHeadlinesCell")
		
		viewModel.loadTopHeadlines {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}


}

extension TopHeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(in: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "TopHeadlinesCell", for: indexPath) as? TopHeadlinesCell, let item = viewModel.item(for: indexPath.row) {
			cell.configure(item)
			
			if let image = item.image {
				cell.setImage(image)
			} else {
				viewModel.loadImage(item.imageURL, indexPath.row) { image in
					DispatchQueue.main.async {
						self.tableView.beginUpdates()
						cell.setImage(image)
						self.tableView.endUpdates()
					}
				}
			}
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	
}
