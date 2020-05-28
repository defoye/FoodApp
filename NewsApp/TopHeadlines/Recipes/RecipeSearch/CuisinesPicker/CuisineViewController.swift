//
//  CuisineViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class CuisineViewController: UIViewController {
	
	let tableView = UITableView(frame: .zero, style: .plain)
	weak var delegate: RecipeSearchCoordinatorDelegate?
	let items: [SpoonacularAPI.Cuisine] = SpoonacularAPI.Cuisine.allCases
	
	override func viewDidLoad() {
		setupTableView()

		title = "Choose a Cuisine"
		
		navigationController?.navigationBar.isTranslucent = false
		
		let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
		navigationItem.rightBarButtonItem = cancelButtonItem
		navigationController?.navigationBar.tintColor = .black
	}
	
	@objc func cancelAction() {
		dismiss(animated: true, completion: nil)
	}
	
	func setupTableView() {
		let cuisineCellNib = UINib.init(nibName: "CuisineCell", bundle: .current)
		tableView.register(cuisineCellNib, forCellReuseIdentifier: "CuisineCell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
		view.addSubview(tableView)
		tableView.pin(to: view)
	}
}

extension CuisineViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = items.count
		return count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "CuisineCell") as? CuisineCell {
			cell.configure(items[indexPath.row].title, nil)
			return cell
		}
		
		fatalError()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.cuisineSelected(items[indexPath.row])
		dismiss(animated: true, completion: nil)
	}
}
