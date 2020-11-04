//
//  RecipeDetailViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
	
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        let headerCellNib = UINib.init(nibName: "RecipeDetailHeaderCell", bundle: .current)
        tableView.register(headerCellNib, forCellReuseIdentifier: "RecipeDetailHeaderCell")
        let ingredientCellNib = UINib.init(nibName: "RecipeDetailIngredientCell", bundle: .current)
        tableView.register(ingredientCellNib, forCellReuseIdentifier: "RecipeDetailIngredientCell")
        let instructionCellNib = UINib.init(nibName: "RecipeDetailInstructionCell", bundle: .current)
        tableView.register(instructionCellNib, forCellReuseIdentifier: "RecipeDetailInstructionCell")
        let similarRecipeCellNib = UINib.init(nibName: "RecipeSimilarCell", bundle: .current)
        tableView.register(similarRecipeCellNib, forCellReuseIdentifier: "RecipeSimilarCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 0, left: 0, bottom: 150, right: 0)
        tableView.estimatedSectionHeaderHeight = 25
        return tableView
    }()
	
	var viewModel: RecipeDetailViewModel!
		
	func initViewModel(_ viewModel: RecipeDetailViewModel) {
		self.viewModel = viewModel
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        addSubviewsAndConstraints()
		
		viewModel.fetchData {
			self.reloadTableView()
		}
	}
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableView)
        tableView.pin(to: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func setupNavBar() {
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = .init(title: nil, image: Constants.Images.heart.image, primaryAction: .init(handler: { action in
                guard let extractModel = self.viewModel.extractModel else {
                    return
                }
                FirebaseDataManager.shared.addFavoriteRecipe(self.viewModel.searchOriginalObject, similarModel: self.viewModel.similarOriginalObject, firebaseModel: self.viewModel.firebaseOriginalObject, extractModel)
            }), menu: nil)
        } else {
            navigationItem.rightBarButtonItem = .init(image: Constants.Images.heart.image, style: .plain, target: self, action: #selector(favoritesTapped))
        }
    }
    
    @objc
    func favoritesTapped() {
        guard let extractModel = self.viewModel.extractModel else {
            return
        }
        FirebaseDataManager.shared.addFavoriteRecipe(self.viewModel.searchOriginalObject, similarModel: self.viewModel.similarOriginalObject, firebaseModel: self.viewModel.firebaseOriginalObject, extractModel)
    }
	
	func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.separatorStyle = self.viewModel.isLoading ? .none : .singleLine
			self.tableView.reloadData()
//			self.tableView.beginUpdates()
//			self.tableView.endUpdates()
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
				cell.configure(item)
				return cell
			}
		case .instructions:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailInstructionCell") as? RecipeDetailInstructionCell, let item = viewModel.instructionItem(at: indexPath.row) {
				cell.configure(item)
				return cell
			}
		case .similarRecipes:
			if let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeSimilarCell") as? RecipeSimilarCell, let item = viewModel.similarRecipeItem(at: indexPath.row) {
				cell.configure(item)
				return cell
			}
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = tableView.cellForRow(at: indexPath)
		
		if let ingredientCell = selectedCell as? RecipeDetailIngredientCell {
			tableView.beginUpdates()
			ingredientCell.toggleTitleLabelText()
			tableView.endUpdates()
		} else if selectedCell is RecipeSimilarCell {
			guard let item = viewModel.similarRecipeItem(at: indexPath.row), let sourceURL = item.sourceURL else {
				return
			}
			guard let url = URL(string: sourceURL), let presenter = navigationController else {
				return
			}

			let vc = RecipeDetailViewController()
			let vm = RecipeDetailViewModel(sourceURL, item)
			vc.initViewModel(vm)
			
			presenter.pushViewController(vc, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let section = RecipeDetailSection(rawValue: section) else {
			fatalError()
		}
		
		switch section {
		case .header:
			return 0
		case .ingredients:
			return viewModel.isLoading ? 0 : UITableView.automaticDimension
		case .instructions:
			return viewModel.isLoading ? 0 : UITableView.automaticDimension
		case .similarRecipes:
			return viewModel.isLoading ? 0 : UITableView.automaticDimension
		}
	}
	
	private func headerView(for title: String) -> UIView {
		let headerView = UIView()
		let tileView = UIView()
		let label = UILabel()

		headerView.backgroundColor = tableView.backgroundColor ?? .white
		tileView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		headerView.addSubview(tileView)
		tileView.addSubview(label)
        tileView.pin(to: headerView, insets: .init(top: 20, left: 20, bottom: -10, right: -20))
		label.pin(to: tileView)
		label.text = title
		label.font = UIFont(name: "Avenir-Heavy", size: 24)
		
		return headerView
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let section = RecipeDetailSection(rawValue: section) else {
			fatalError()
		}
		
		switch section {
		case .header:
			return nil
		case .ingredients:
			return viewModel.isLoading ? nil : headerView(for: "Ingredients")
		case .instructions:
			return viewModel.isLoading ? nil : headerView(for: "Instructions")
		case .similarRecipes:
			return viewModel.isLoading ? nil : headerView(for: "Similar Recipes")
		}
	}
}
