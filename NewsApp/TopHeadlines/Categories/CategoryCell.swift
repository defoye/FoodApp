//
//  CategoryCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var chevronImageView: UIImageView!
	
	func configure(_ item: TopHeadlinesCategoriesViewModel.Item) {
		super.awakeFromNib()
		selectionStyle = .none
		tileView.layer.cornerRadius = 5
		titleLabel.text = item.title
		titleLabel.font = UIFont(name: "Avenir-Book", size: 24)
		chevronImageView.image = UIImage(named: "chevron_right")
		
		tileView.backgroundColor = .separator
	}
}
