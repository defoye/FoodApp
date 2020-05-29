//
//  RecipesViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

extension RecipesViewController: RecipesLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
//	if let cell = collectionView.cellForItem(at: indexPath) as? RecipeCell {
//		let height = cell.height()
//		return height
//	}
	
    return 200
  }
}

class RecipesViewController: UIViewController {
	
//	var collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecipesLayout())
	
	var collectionView = UICollectionView(frame: .zero, collectionViewLayout: RecipesLayout())

	var viewModel: RecipesViewModel!
		
	func initViewModel(_ viewModel: RecipesViewModel) {
		self.viewModel = viewModel
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		setupCollectionView()
		
		title = "Tsatsa's Recipe Search Results"
		
		view.backgroundColor = .white
		
		view.addSubview(collectionView)
		collectionView.pin(to: view)
		
		let params = viewModel.createParams(false, .american)
		viewModel.loadRecipes(params) {
			self.reloadCollectionView()
		}
		
//		if let layout = collectionView.collectionViewLayout as? RecipesLayout {
//		  layout.delegate = self
//		}
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
	
	func reloadCollectionView() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
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
			let vm = RecipeDetailViewModel(sourceURL)
			vc.initViewModel(vm)
			
			presenter.pushViewController(vc, animated: true)
			
//			UIApplication.shared.open(url)
		}
	}
}
