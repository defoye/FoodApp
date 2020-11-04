//
//  RecipeDetailHeaderCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailHeaderCell: UITableViewCell {
    
    static let reuseIdentifier = "RecipeDetailHeaderCell"
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var recipeImageView: UIImageView!
	@IBOutlet weak var recipeTitleLabel: UILabel!
	@IBOutlet weak var recipeImageViewHeightConstraint: NSLayoutConstraint!
	
	func configure(_ item: RecipeDetailViewModel.HeaderItem) {
		super.awakeFromNib()
		selectionStyle = .none
		contentView.layoutIfNeeded()
		recipeTitleLabel.text = item.title
		recipeTitleLabel.font = UIFont(name: "Avenir-Heavy", size: 32)
		recipeTitleLabel.numberOfLines = 0
		recipeImageView.contentMode = .scaleAspectFill
		recipeImageView.backgroundColor = .separator
		recipeImageViewHeightConstraint.constant = tileView.frame.width * 0.67
		recipeImageView.image = item.image
	}
}
