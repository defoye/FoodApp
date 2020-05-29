//
//  RecipeDetailHeaderCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol RecipeDetailHeaderCellDelegate: class {
	func setImage(_ image: UIImage)
}

class RecipeDetailHeaderCell: UITableViewCell, RecipeDetailHeaderCellDelegate {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var recipeImageView: UIImageView!
	@IBOutlet weak var recipeTitleLabel: UILabel!
	@IBOutlet weak var recipeImageViewHeightConstraint: NSLayoutConstraint!
	
	func configure(_ item: RecipeDetailViewModel.HeaderItem) {
		super.awakeFromNib()
		contentView.layoutIfNeeded()
		tileView.backgroundColor = .orange
		recipeImageView.contentMode = .scaleAspectFill
		recipeImageView.backgroundColor = .separator
		recipeImageViewHeightConstraint.constant = tileView.frame.width * 0.67
	}
	
	func setImage(_ image: UIImage) {
		recipeImageView.image = image
	}
}
