//
//  RecipeSimilarCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/30/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeSimilarCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var recipeImageView: UIImageView!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	private func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		recipeImageView.layer.cornerRadius = 5
		titleLabel.numberOfLines = 0
		recipeImageView.contentMode = .scaleAspectFill
	}
	
	func configure(_ item: RecipeDetailViewModel.SimilarRecipeItem) {
		setup()
		titleLabel.text = item.title
		timeLabel.text = item.timeTitle
		recipeImageView.image = item.image
	}
}
