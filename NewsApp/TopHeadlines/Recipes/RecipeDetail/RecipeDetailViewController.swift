//
//  RecipeDetailViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, Storyboarded {
	
	@IBOutlet weak var tableView: UITableView!
	
	var viewModel: RecipeDetailViewModel!
	
	weak var headerDelegate: RecipeDetailHeaderCellDelegate?
	
	func initViewModel(_ viewModel: RecipeDetailViewModel) {
		self.viewModel = viewModel
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.loadRecipeDetails {
			self.reloadTableView()
		}
		
		let headerCellNib = UINib.init(nibName: "RecipeDetailHeaderCell", bundle: .current)
		tableView.register(headerCellNib, forCellReuseIdentifier: "RecipeDetailHeaderCell")
		let ingredientCellNib = UINib.init(nibName: "RecipeDetailIngredientCell", bundle: .current)
		tableView.register(ingredientCellNib, forCellReuseIdentifier: "RecipeDetailIngredientCell")
		let instructionCellNib = UINib.init(nibName: "RecipeDetailInstructionCell", bundle: .current)
		tableView.register(instructionCellNib, forCellReuseIdentifier: "RecipeDetailInstructionCell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return RecipeDetailSection.allCases.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let section = RecipeDetailSection(rawValue: section) else {
			fatalError()
		}
		
		return viewModel.numberOfRows(in: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let section = RecipeDetailSection(rawValue: indexPath.section) else {
			fatalError()
		}
		
		switch section {
		case .header:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailHeaderCell") as? RecipeDetailHeaderCell, let item = viewModel.headerItem() {
				cell.configure(item)
				return cell
			}
		case .ingredients:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailIngredientCell") as? RecipeDetailIngredientCell, let item = viewModel.ingredientItem(at: indexPath.row) {
				cell.backgroundColor = .blue
				cell.configure(item)
				return cell
			}
		case .instructions:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailInstructionCell") as? RecipeDetailInstructionCell, let item = viewModel.instructionItem(at: indexPath.row) {
				cell.backgroundColor = .red
				cell.configure(item)
				return cell
			}
		}
		return UITableViewCell()
	}
}
