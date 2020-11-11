//
//  RecipeSearchViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit
import QuiteAdaptableKit

enum RecipeSearchRow: Int, CaseIterable {
	case query
	case cuisine
	case dishType
	case instructionsRequired
}

class RecipeSearchViewController: UIViewController, Storyboarded {
	@IBOutlet weak var searchButtonView: UIView!
	
	@IBOutlet weak var searchButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
    
    enum Section {
        case main
    }
    
    enum Item: CaseIterable {
        case searchBar
        case cuisinePicker
        case dishPicker
        case instructionsRequired
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        UITableViewDiffableDataSource<Section, Item>(tableView: self.tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .searchBar:
                return tableView.configuredCell(SearchBarTableViewCell.self, identifier: "SearchBarTableViewCell") { cell in
                    let model = SearchBarTableViewCell.Model()
                    model.insets = .init(top: 20, left: 20, bottom: 20, right: 20)
                    model.placeholder = "Search"
                    model.enablesReturnKeyAutomatically = false
                    model.returnKeyType = .done
                    cell.configure(model)
                    self.searchBarCellDelegate = cell
                }
            case .cuisinePicker:
                return tableView.configuredCell(CuisineCell.self, identifier: "CuisineCell") { cell in
                    cell.configure("Cuisine", self.cuisineSelected?.title ?? "None")
                }
            case .dishPicker:
                return tableView.configuredCell(CuisineCell.self, identifier: "CuisineCell") { cell in
                    cell.configure("Dish Type", self.dishTypeSelected?.title ?? "None")
                }
            case .instructionsRequired:
                return tableView.configuredCell(InstructionsRequiredCell.self, identifier: "InstructionsRequiredCell") { cell in
                    cell.configure(delegate: self, switchIsOn: self.instructionsRequired)
                }
            }
        }
    }()
    
    lazy var snapshot: NSDiffableDataSourceSnapshot<Section, Item> = {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        /**
            Removing instructions required from Recipe Search
         */
//        snapshot.appendItems([.searchBar, .cuisinePicker, .dishPicker, .instructionsRequired])
        snapshot.appendItems([.searchBar, .cuisinePicker, .dishPicker])
        return snapshot
    }()
	
	weak var coordinatorDelegate: RecipeSearchCoordinatorDelegate?
    weak var searchBarCellDelegate: SearchBarTableViewCellDelegate?
	
	var cuisineSelected: SpoonacularAPI.Cuisine?
	var dishTypeSelected: SpoonacularAPI.DishType?

	var instructionsRequired: Bool = false
	var mostPopular: Bool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
		
		searchButton.layer.cornerRadius = 5
		searchButton.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
		searchButton.setTitle("Search", for: .normal)
		searchButton.setTitleColor(.black, for: .normal)
		searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
				
		navigationItem.title = "Recipe Search"
		
		let cuisineCellNib = UINib.init(nibName: "CuisineCell", bundle: .current)
		tableView.register(cuisineCellNib, forCellReuseIdentifier: "CuisineCell")
		let instructionsRequiredCellNib = UINib.init(nibName: "InstructionsRequiredCell", bundle: .current)
		tableView.register(instructionsRequiredCellNib, forCellReuseIdentifier: "InstructionsRequiredCell")
        tableView.separatorStyle = .none
		tableView.delegate = self
        tableView.dataSource = dataSource
        reloadTableView()
	}
	
	@objc func searchButtonAction() {
        var passThroughData: SpoonacularAPI.ComplexSearch.ParamDict = [
            .instructionsRequired: String(instructionsRequired)
		]
		if let cuisine = cuisineSelected, cuisine != .none {
            passThroughData[.cuisine] = cuisine.param
		}
		if let type = dishTypeSelected {
            passThroughData[.type] = type.rawValue
		}
		if mostPopular {
            passThroughData[.sort] = "popularity"
		}
		if let searchText = searchBarCellDelegate?.textFieldValue {
            passThroughData[.query] = searchText
		}
		coordinatorDelegate?.coordinateToRecipesList(passThroughData)
	}
	
    func reloadTableView() {
		DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot)
		}
	}
    
    func reloadItems(_ items: [Item]) {
        snapshot.reloadItems(items)
        reloadTableView()
    }
}

extension RecipeSearchViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let row = RecipeSearchRow(rawValue: indexPath.row) else {
			return
		}
		
		switch row {
		case .query:
			break
		case .cuisine:
			coordinatorDelegate?.coordinateToCuisinePicker(.cuisine)
		case .dishType:
			coordinatorDelegate?.coordinateToCuisinePicker(.dish)
		case .instructionsRequired:
			break
		}
	}
}

extension RecipeSearchViewController: InstructionsRequiredCellDelegate {
	func mostPopularSwitchSelectionChanged(_ isOn: Bool) {
		mostPopular = isOn
	}
	
	func switchSelectionChanged(_ isOn: Bool) {
		instructionsRequired = isOn
	}
}
