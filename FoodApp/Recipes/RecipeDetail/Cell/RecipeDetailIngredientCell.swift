//
//  RecipeDetailIngredientCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailIngredientCell: UITableViewCell {
    
    static let reuseIdentifier = "RecipeDetailIngredientCell"
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var infoImageView: UIImageView!
	
	var item: RecipeDetailViewModel.IngredientItem?
	var isPrimaryState: Bool = true
	
	func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		infoImageView.image = UIImage(named: "info")
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont(name: "Avenir-Book", size: 16)
	}
	
	func configure(_ item: RecipeDetailViewModel.IngredientItem) {
		setup()
		titleLabel.text = item.primaryTitleLabelText
		
		self.item = item
	}
	
	func toggleTitleLabelText() {
		isPrimaryState = !isPrimaryState
		titleLabel.text = isPrimaryState ? item?.primaryTitleLabelText : item?.secondaryTitleLabelText
	}
}
