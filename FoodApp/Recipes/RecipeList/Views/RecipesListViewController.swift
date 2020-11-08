//
//  RecipesListViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipesListViewController: BaseViewController {
		
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let recipeCellNib = UINib.init(nibName: "RecipeListCell", bundle: .current)
        collectionView.register(recipeCellNib, forCellWithReuseIdentifier: "RecipeCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
		return collectionView
	}()
	
	private let viewModel: RecipeListViewModel
	/// Height of the last cell configured. Will be the max of two cell heights.
	private var lastHeight: CGFloat = 0
    override var fetchDistanceMultiplier: CGFloat {
		return 2
	}
    
    init(_ viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	// TODO
	private lazy var loadingView: UIView = {
		let loadingView = UIView()
		loadingView.translatesAutoresizingMaskIntoConstraints = false
		loadingView.backgroundColor = .systemBackground
		let label = UILabel()
		label.text = "Loading recipes..."
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "Avenir-Book", size: 24)
		label.textAlignment = .center
		label.pin(to: loadingView)
		return loadingView
	}()
	
	func addLoadingView() {
        DispatchQueue.main.async {
            self.collectionView.addSubview(self.loadingView)
            self.loadingView.pin(to: self.collectionView)
        }
	}
	
	func removeLoadingView() {
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
        }
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		addLoadingView()
		
		title = "Recipe Search Results"
//        view.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
		view.addSubview(collectionView)
		collectionView.pin(to: view)
		
		let params = viewModel.createParams(instructionsRequired: false)
		viewModel.loadComplexRecipes(params) {
			self.removeLoadingView()
			self.collectionView.reloadDataOnMain()
		}
		
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
		
	// TODO
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		super.scrollViewDidScroll(scrollView)
		
		if viewModel.hasMoreContent && super.inScrollFetchRange {
			super.nextPageCalled = true
			let params = viewModel.createParams(instructionsRequired: false)
			viewModel.loadComplexRecipes(params) {
				self.collectionView.reloadDataOnMain()
				super.nextPageCalled = false
			}
		}
	}
}

extension RecipesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let squareSideLength = (collectionView.frame.width) / 2
		if indexPath.row % 2 == 0 {
			if let item = viewModel.item(for: indexPath.row), let nextItem = viewModel.item(for: indexPath.row + 1) {
				let height1 = RecipeListCell.height(collectionView.frame.width, item.title, item.timeTitle)
				let height2 = RecipeListCell.height(collectionView.frame.width, nextItem.title, nextItem.timeTitle)
				
				lastHeight = max(height1, height2)

				return CGSize(width: squareSideLength, height: lastHeight)
			}
		} else {
			return CGSize(width: squareSideLength, height: lastHeight)
		}
		if let item = viewModel.item(for: indexPath.row) {
			let height = RecipeListCell.height(collectionView.frame.width, item.title, item.timeTitle)
			return CGSize(width: squareSideLength, height: height)
		}
		
		return CGSize(width: squareSideLength, height: squareSideLength)
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems(in: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as? RecipeListCell, let item = viewModel.item(for: indexPath.row) {
			cell.configure(item)
			
			return cell
		}
		
		fatalError()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let item = viewModel.item(for: indexPath.row), let sourceURL = item.sourceURL {
			guard let presenter = navigationController else {
				return
			}

            let vm = RecipeDetailViewModel(sourceURL, item)
			let vc = RecipeDetailViewController(vm)
			
			presenter.pushViewController(vc, animated: true)
        }
	}
}
