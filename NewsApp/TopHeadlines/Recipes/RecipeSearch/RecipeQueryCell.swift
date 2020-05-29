//
//  RecipeQueryCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipeQueryCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var searchTextFieldLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	private func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		searchTextFieldLabel.font = UIFont(name: "Avenir-Book", size: 16)
	}
	
	func configure() {
		setup()
	}
}

extension RecipeQueryCell: UITextFieldDelegate {
	
}
