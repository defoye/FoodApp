//
//  RecipesViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
		
	var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		return UICollectionView(frame: .zero, collectionViewLayout: layout)
	}()
	
	var viewModel: RecipesViewModel!
		
	func initViewModel(_ viewModel: RecipesViewModel) {
		self.viewModel = viewModel
	}
	
	// TODO
	private lazy var loadingView: UIView = {
		let loadingView = UIView()
		loadingView.translatesAutoresizingMaskIntoConstraints = false
		loadingView.backgroundColor = .white
		let label = UILabel()
		label.text = "Loading recipes..."
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "Avenir-Book", size: 24)
		label.textAlignment = .center
		label.pin(to: loadingView)
		return loadingView
	}()
	
	func addLoadingView() {
		collectionView.addSubview(loadingView)
		loadingView.pin(to: collectionView)
	}
	
	func removeLoadingView() {
		loadingView.removeFromSuperview()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		setupCollectionView()
		addLoadingView()
		NSLayoutConstraint.activate([
			loadingView.heightAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 1),
			loadingView.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1),
			loadingView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
		])
		
		title = "Tsatsa's Recipe Search Results"
		
		view.backgroundColor = .white
		
		view.addSubview(collectionView)
		collectionView.pin(to: view)
		
		let params = viewModel.createParams(false, .american)
		viewModel.loadComplexRecipes(params) {
			self.removeLoadingView()
			self.reloadCollectionView()
		}
		
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
	
	func setupCollectionView() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .white
		let recipeCellNib = UINib.init(nibName: "RecipeCell", bundle: .current)
		collectionView.register(recipeCellNib, forCellWithReuseIdentifier: "RecipeCell")
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	
	// TODO
	func reloadCollectionView() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
	
	var previousOffset: CGFloat = 0
	var nextPageCalled: Bool = false
	
	// TODO
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let contentHeight = scrollView.contentSize.height
		let frameHeight = scrollView.frame.height
		let currentY = scrollView.contentOffset.y
		let newContentScrollThreshold = contentHeight - currentY <= frameHeight * 2
		let isScrollingDown = currentY - previousOffset > 0
		let shouldLoadMoreContent = newContentScrollThreshold
									&& isScrollingDown
									&& !nextPageCalled
									&& viewModel.hasMoreContent
		
		if shouldLoadMoreContent {
			nextPageCalled = true
			let params = viewModel.createParams(false, .american)
			viewModel.loadComplexRecipes(params) {
				self.reloadCollectionView()
				self.nextPageCalled = false
			}
		}
		
		previousOffset = currentY
	}
	
	var lastHeight: CGFloat = 0
}

extension RecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let squareSideLength = (collectionView.frame.width) / 2
		if indexPath.row % 2 == 0 {
			if let item = viewModel.item(for: indexPath.row), let nextItem = viewModel.item(for: indexPath.row + 1) {
				let height1 = RecipeCell.height(collectionView.frame.width, item.title, item.timeTitle)
				let height2 = RecipeCell.height(collectionView.frame.width, nextItem.title, nextItem.timeTitle)
				
				lastHeight = max(height1, height2)

				return CGSize(width: squareSideLength, height: lastHeight)
			}
		} else {
			return CGSize(width: squareSideLength, height: lastHeight)
		}
		if let item = viewModel.item(for: indexPath.row) {
			let height = RecipeCell.height(collectionView.frame.width, item.title, item.timeTitle)
			return CGSize(width: squareSideLength, height: height)
		}
		
		return CGSize(width: squareSideLength, height: squareSideLength)
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.numberOfItems(in: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as? RecipeCell, let item = viewModel.item(for: indexPath.row) {
			cell.configure(item)
			
			return cell
		}
		
		fatalError()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let item = viewModel.item(for: indexPath.row), let sourceURL = item.sourceURL {
			guard let url = URL(string: sourceURL), let presenter = navigationController else {
				return
			}

			let vc = RecipeDetailViewController.instantiate("RecipeDetail")
			let vm = RecipeDetailViewModel(sourceURL, item)
			vc.initViewModel(vm)
			
			presenter.pushViewController(vc, animated: true)
			
//			UIApplication.shared.open(url)
		}
	}
}
