//
//  TopHeadlinesCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class TopHeadlinesCell: UITableViewCell {
	
	@IBOutlet weak var mainStackView: UIStackView!

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var sourceLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var articleImageViewHeight: NSLayoutConstraint!
	
	func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		articleImageView.image = nil
		articleImageView.contentMode = .scaleAspectFill
		articleImageView.layer.cornerRadius = 5
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let width = mainStackView.frame.width
		articleImageViewHeight.constant = width * 0.67
	}
	
	func configure(_ item: TopHeadlinesViewModel.Item) {
		setup()
		
		sourceLabel.text = item.source
		sourceLabel.font = UIFont(name: "Avenir-Heavy", size: 20)
		titleLabel.text = item.title
		titleLabel.font = UIFont(name: "Avenir-Book", size: 20)
		titleLabel.numberOfLines = 0
		if let author = item.author, !author.isEmpty {
			authorLabel.text = "by \(author)"
		} else {
			authorLabel.text = nil
		}
		authorLabel.font = UIFont(name: "Avenir-Book", size: 13)
		
		authorLabel.isHidden = true

		dateLabel.text = item.date
		dateLabel.font = UIFont(name: "Avenir-Book", size: 16)
	}
	
	func setImage(_ image: UIImage) {
		// TODO:
		articleImageView.image = image
		contentView.layoutIfNeeded()
		let articleWidth = self.articleImageView.frame.width
		let articleHeight = articleWidth * 0.67
		articleImageViewHeight.constant = articleHeight
	}
}
