//
//  RecipeDetailViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    enum Section: Hashable {
        case header
        case ingredients
        case instructions
        case similarRecipes
    }
    
    enum Item: Hashable {
        case labelItem(_ model: LabelCell.Model)
        case header(_ model: RecipeDetailViewModel.HeaderItem)
        case ingredient(_ model: RecipeDetailViewModel.IngredientItem)
        case instruction(_ model: RecipeDetailViewModel.InstructionItem)
        case similarRecipe(_ model: RecipeDetailViewModel.SimilarRecipeItem)
        case error(_ text: String)
        
        enum Style {
            case short
            case long
        }
        case separatorItem(_ uuid: UUID, _ style: Style)
    }
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            switch item {
            case .header(let model):
                return tableView.configuredCell(RecipeDetailHeaderCell.self, identifier: RecipeDetailHeaderCell.reuseIdentifier) { cell in
                    cell.configure(model)
                }
            case .ingredient(let model):
                return tableView.configuredCell(RecipeDetailIngredientCell.self, identifier: RecipeDetailIngredientCell.reuseIdentifier) { cell in
                    cell.configure(model)
                }
            case .instruction(let model):
                return tableView.configuredCell(RecipeDetailInstructionCell.self, identifier: RecipeDetailInstructionCell.reuseIdentifier) { cell in
                    cell.configure(model)
                }
            case .similarRecipe(let model):
                return tableView.configuredCell(RecipePreviewTableViewCell.self, identifier: RecipePreviewTableViewCell.reuseIdentifier) { cell in
                    cell.configure(model)
                }
            case .labelItem(let model):
                return tableView.configuredCell(LabelCell.self) { cell in
                    cell.configure(model)
                }
            case .separatorItem(_, let style):
                return tableView.configuredCell(BlankTableViewCell.self) { cell in
                    let view = UIView()
                    view.backgroundColor = .lightGray
                    view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                    let viewModel = BlankTableViewCell.ViewModel()
                    switch style {
                    case .short: viewModel.viewInsets = .init(top: 0, left: 110, bottom: 0, right: 0)
                    case .long: viewModel.viewInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
                    }
                    cell.configure(view, viewModel: viewModel)
                }
            case .error(let text):
                return tableView.configuredCell(ErrorCell.self) { cell in
                    cell.configure(text, .init(top: 0, left: 0, bottom: -20, right: 0))
                }
            }
        }
    }()
	
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        let headerCellNib = UINib.init(nibName: "RecipeDetailHeaderCell", bundle: .current)
        tableView.register(headerCellNib, forCellReuseIdentifier: "RecipeDetailHeaderCell")
        let ingredientCellNib = UINib.init(nibName: "RecipeDetailIngredientCell", bundle: .current)
        tableView.register(ingredientCellNib, forCellReuseIdentifier: "RecipeDetailIngredientCell")
        let instructionCellNib = UINib.init(nibName: "RecipeDetailInstructionCell", bundle: .current)
        tableView.register(instructionCellNib, forCellReuseIdentifier: "RecipeDetailInstructionCell")
        tableView.register(RecipePreviewTableViewCell.self, forCellReuseIdentifier: RecipePreviewTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 0, left: 0, bottom: 150, right: 0)
        return tableView
    }()
	
	let viewModel: RecipeDetailViewModel
		
    init(_ viewModel: RecipeDetailViewModel) {
		self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = dataSource
        self.viewModel.dataSourceApplyBlock = { [weak self] snapshot in
            guard let self = self else {
                return
            }
            
            self.dataSource.apply(snapshot)
        }
        self.viewModel.favoriteButtonEnableBlock = { [weak self] isLoadingRecipeDetail, isFavoriteRecipe in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = !isLoadingRecipeDetail && !isFavoriteRecipe
            }
        }
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        addSubviewsAndConstraints()
        viewModel.fetchData()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableView)
        tableView.pin(to: view)
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = .init(image: Constants.Images.heart.image, style: .plain, target: self, action: #selector(favoritesTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc
    func favoritesTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        viewModel.toggleFavoriteRecipe()
    }
}

extension RecipeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch item {
        case .labelItem(_), .header(_), .instruction(_), .separatorItem(_):
            break
        case .ingredient(_):
            if let ingredientCell = tableView.cellForRow(at: indexPath) as? RecipeDetailIngredientCell {
                tableView.beginUpdates()
                ingredientCell.toggleTitleLabelText()
                tableView.endUpdates()
            }
        case .similarRecipe(let model):
            guard let sourceURL = model.sourceURL else {
                return
            }
            guard let presenter = navigationController else {
                return
            }

            let vm = RecipeDetailViewModel(sourceURL, model)
            let vc = RecipeDetailViewController(vm)

            presenter.pushViewController(vc, animated: true)
        case .error(_):
            viewModel.fetchData()
        }
    }
}
