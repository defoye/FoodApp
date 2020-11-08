//
//  RecipeListCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeListCell: UICollectionViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var mainStackView: UIStackView!
	@IBOutlet weak var recipeImageView: UIImageView!
	@IBOutlet weak var recipeImageViewHeight: NSLayoutConstraint!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	
	func setup() {
		super.awakeFromNib()
		recipeImageView.image = nil
		recipeImageView.contentMode = .scaleAspectFill
		recipeImageView.layer.cornerRadius = 5
		contentView.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.pin(to: self)
	}
		
	func configure(_ item: RecipeListViewModel.Item) {
		setup()
		titleLabel.text = item.title
		titleLabel.font = RecipeListCell.titleFont
		timeLabel.font = RecipeListCell.timeFont
		timeLabel.text = item.timeTitle
		setImage(item.image)
		
		titleLabel.numberOfLines = 0
	}
	
	func setImage(_ image: UIImage) {
		recipeImageView.image = image
		contentView.layoutIfNeeded()
		let recipeWidth = self.recipeImageView.frame.width
		let recipeHeight = recipeWidth * 0.67
		recipeImageViewHeight.constant = recipeHeight
	}
	
	static let titleFont = UIFont(name: "Avenir-Heavy", size: 16)
	static let timeFont = UIFont(name: "Avenir-Book", size: 16)

	static func height(_ collectionViewWidth: CGFloat, _ titleText: String?, _ timeText: String?) -> CGFloat {
		var total: CGFloat = 0
		total += 5 + 5
		total += 10 + 10

		total += ((collectionViewWidth / 2) - 10 - 10) * 0.67
		
		let labelWidth: CGFloat = (collectionViewWidth - 40) / 2
		
		if let text = titleText {
			total += heightForView(text: text, font: titleFont!, width: labelWidth)
		}
		if let text = timeText {
			total += heightForView(text: text, font: timeFont!, width: labelWidth)
		}

		return total
	}
	
	static func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
		let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = NSLineBreakMode.byWordWrapping
		label.font = font
		label.text = text

		label.sizeToFit()
		return label.frame.height
	}
}
