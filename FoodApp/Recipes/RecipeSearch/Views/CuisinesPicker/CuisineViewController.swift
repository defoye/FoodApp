//
//  CuisineViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

enum RecipePickerType {
	case cuisine
	case dish
}

class CuisineViewController: UIViewController {
	
	let tableView = UITableView(frame: .zero, style: .plain)
	weak var delegate: RecipeSearchCoordinatorDelegate?
	let cuisineItems: [SpoonacularAPI.Cuisine] = SpoonacularAPI.Cuisine.allCases
	let dishItems: [SpoonacularAPI.DishType] = SpoonacularAPI.DishType.allCases
	
	var type: RecipePickerType?
	
	func initViewModel(type: RecipePickerType) {
		self.type = type
	}

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
		guard let type = type else {
			return 0
		}
		
		switch type {
		case .cuisine:
			return cuisineItems.count
		case .dish:
			return dishItems.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "CuisineCell") as? CuisineCell {
			guard let type = type else {
				fatalError()
			}
			let primaryTitle: String
			switch type {
			case .cuisine:
				primaryTitle = cuisineItems[indexPath.row].title
			case .dish:
				primaryTitle = dishItems[indexPath.row].title
			}
			cell.configure(primaryTitle, nil)
			return cell
		}
		
		fatalError()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let type = type else {
			return
		}
		switch type {
		case .cuisine:
			delegate?.cuisineSelected(cuisineItems[indexPath.row])
		case .dish:
			delegate?.dishTypeSelected(dishItems[indexPath.row])
		}
		
		dismiss(animated: true, completion: nil)
	}
}
