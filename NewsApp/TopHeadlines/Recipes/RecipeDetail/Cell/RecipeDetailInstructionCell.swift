//
//  RecipeDetailInstructionCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/28/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeDetailInstructionCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var numberDotView: UIView!
	
	func configure(_ item: RecipeDetailViewModel.InstructionItem) {
		super.awakeFromNib()
		numberDotView.backgroundColor = .separator
		numberDotView.layer.cornerRadius = numberDotView.frame.width / 2
		numberLabel.text = item.number
		numberDotView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		titleLabel.text = item.stepTitle
		titleLabel.numberOfLines = 0
	}
}
