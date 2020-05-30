//
//  RecipeQueryCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol RecipeQueryCellDelegate: class {
	var textFieldValue: String? { get }
}

class RecipeQueryCell: UITableViewCell, RecipeQueryCellDelegate {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var searchTextFieldLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	private func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		searchTextFieldLabel.font = UIFont(name: "Avenir-Book", size: 16)
		searchTextField.delegate = self
		searchTextField.returnKeyType = .done
		searchTextFieldLabel.text = "Recipe search terms"
		searchTextField.clearButtonMode = .whileEditing
//		let bar = UIToolbar()
//		let reset = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
//		reset.tintColor = .black
//		bar.items = [reset]
//		bar.sizeToFit()
//		searchTextField.inputAccessoryView = bar
	}
	
	func configure() {
		setup()
	}
	
	@objc func resetTapped() {
		
	}
	
	var textFieldValue: String? {
		return searchTextField.text
	}
}

extension RecipeQueryCell: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}
}
