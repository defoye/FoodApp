//
//  RecipeDetailIngredientCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailIngredientCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var infoImageView: UIImageView!
	
	var item: RecipeDetailViewModel.IngredientItem?
	var isPrimaryState: Bool = true
	
	func configure(_ item: RecipeDetailViewModel.IngredientItem) {
		super.awakeFromNib()
		selectionStyle = .none
		
		infoImageView.image = UIImage(named: "info")
		titleLabel.text = item.primaryTitleLabelText
		titleLabel.numberOfLines = 0
		
		self.item = item
	}
	
	func toggleTitleLabelText() {
		isPrimaryState = !isPrimaryState
		titleLabel.text = isPrimaryState ? item?.primaryTitleLabelText : item?.secondaryTitleLabelText
	}
}
