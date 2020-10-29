//
//  CuisineCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class CuisineCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var primaryLabel: UILabel!
	@IBOutlet weak var secondaryLabelTileView: UIView!
	@IBOutlet weak var secondaryLabel: UILabel!
	
	func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		secondaryLabelTileView.layer.cornerRadius = 5
		secondaryLabelTileView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
		primaryLabel.font = UIFont(name: "Avenir-Book", size: 16)
		secondaryLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
		tileView.backgroundColor = .clear
	}

	func configure(_ primaryTitle: String, _ secondaryTitle: String?) {
		setup()
		primaryLabel.text = primaryTitle
		
		if let title = secondaryTitle {
			secondaryLabelTileView.isHidden = false
			secondaryLabel.text = title
		} else {
			secondaryLabelTileView.isHidden = true
		}
	}
}
