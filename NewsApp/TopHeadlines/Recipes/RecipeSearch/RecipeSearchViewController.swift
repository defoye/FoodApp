//
//  RecipeSearchViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

enum RecipeSearchRow: Int, CaseIterable {
	case cuisine
	case instructionsRequired
}

class RecipeSearchViewController: UIViewController, Storyboarded {
	@IBOutlet weak var searchButtonView: UIView!
	
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	weak var coordinatorDelegate: RecipeSearchCoordinatorDelegate?
	
	var cuisineSelected: SpoonacularAPI.Cuisine?
	var instructionsRequired: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchButton.layer.cornerRadius = 5
		searchButton.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
		searchButton.setTitle("Search", for: .normal)
		searchButton.setTitleColor(.black, for: .normal)
		searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
				
		tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(named: "cooking_book"), selectedImage: nil)
		navigationItem.title = "Tsatsa's Recipe Search"
//		title = "Recipes"
		
		let cuisineCellNib = UINib.init(nibName: "CuisineCell", bundle: .current)
		tableView.register(cuisineCellNib, forCellReuseIdentifier: "CuisineCell")
		let instructionsRequiredCellNib = UINib.init(nibName: "InstructionsRequiredCell", bundle: .current)
		tableView.register(instructionsRequiredCellNib, forCellReuseIdentifier: "InstructionsRequiredCell")
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	@objc func searchButtonAction() {
		let passThroughData: [String: String] = [
			"cuisine": cuisineSelected?.param ?? "",
			"instructionsRequired": String(instructionsRequired)
		]
		coordinatorDelegate?.coordinateToRecipesList(passThroughData)
	}
	
	func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

extension RecipeSearchViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let row = RecipeSearchRow(rawValue: indexPath.row) else {
			fatalError()
		}
		
		switch row {
		case .cuisine:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "CuisineCell") as? CuisineCell {
				cell.configure("Cuisine", cuisineSelected?.title ?? "none")
				return cell
			}
		case .instructionsRequired:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsRequiredCell") as? InstructionsRequiredCell {
				cell.configure(delegate: self)
				return cell
			}
		}
		
		fatalError()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let row = RecipeSearchRow(rawValue: indexPath.row) else {
			return
		}
		
		switch row {
		case .cuisine:
			coordinatorDelegate?.coordinateToCuisinePicker()
		case .instructionsRequired:
			break
		}
	}
}

extension RecipeSearchViewController: InstructionsRequiredCellDelegate {
	func switchSelectionChanged(_ isOn: Bool) {
		instructionsRequired = isOn
	}
}
