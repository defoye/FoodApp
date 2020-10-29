//
//  InstructionsRequiredCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/27/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol InstructionsRequiredCellDelegate: class {
	func switchSelectionChanged(_ isOn: Bool)
	func mostPopularSwitchSelectionChanged(_ isOn: Bool)
}

class InstructionsRequiredCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var instructionsRequiredLabel: UILabel!
	@IBOutlet weak var instructionsRequiredSwitch: UISwitch!
	
	private weak var delegate: InstructionsRequiredCellDelegate?
	
	func setup() {
		super.awakeFromNib()
		selectionStyle = .none
		instructionsRequiredSwitch.addTarget(self, action: #selector(switchSelectionChanged), for: .valueChanged)
		instructionsRequiredLabel.font = UIFont(name: "Avenir-Book", size: 16)
		instructionsRequiredSwitch.isOn = false
		tileView.backgroundColor = .clear

	}
	
	func configure(delegate: InstructionsRequiredCellDelegate, switchIsOn: Bool) {
		setup()
		self.delegate = delegate
		instructionsRequiredSwitch.isOn = switchIsOn
		instructionsRequiredLabel.text = "Instructions required"
	}
	
	func configure(title: String, delegate: InstructionsRequiredCellDelegate) {
		setup()
		self.delegate = delegate
		instructionsRequiredLabel.text = title
	}
	
	@objc func switchSelectionChanged() {
		if instructionsRequiredLabel.text == "Instructions required" {
			delegate?.switchSelectionChanged(instructionsRequiredSwitch.isOn)
		} else {
			delegate?.mostPopularSwitchSelectionChanged(instructionsRequiredSwitch.isOn)
		}
	}
}
