//
//  TopHeadlinesCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class TopHeadlinesCell: UITableViewCell {
	
	@IBOutlet weak var sourceLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	@IBOutlet weak var articleImageViewHeight: NSLayoutConstraint!

	func setup() {
		super.awakeFromNib()
		selectionStyle = .none
	}
	
	func configure(_ item: TopHeadlinesViewModel.Item) {
		setup()
		
		sourceLabel.text = item.source
		sourceLabel.font = UIFont(name: "Avenir-Book", size: 24)
		titleLabel.text = item.title
		titleLabel.font = UIFont(name: "Avenir-Book", size: 16)
		titleLabel.numberOfLines = 0
		if let author = item.author, !author.isEmpty {
			authorLabel.text = "by \(author)"
		} else {
			authorLabel.text = nil
		}
		authorLabel.font = UIFont(name: "Avenir-Book", size: 13)

		
		descriptionLabel.text = item.description
		descriptionLabel.font = UIFont(name: "Avenir-Book", size: 16)
		descriptionLabel.numberOfLines = 0

		dateLabel.text = item.date
		dateLabel.font = UIFont(name: "Avenir-Book", size: 16)
	}
	
	func setImage(_ image: UIImage) {
		articleImageView.image = image
		contentView.layoutIfNeeded()

		let ratio = image.size.width / image.size.height
		let newHeight = self.articleImageView.frame.width / ratio
		articleImageViewHeight.constant = newHeight
	}
}
