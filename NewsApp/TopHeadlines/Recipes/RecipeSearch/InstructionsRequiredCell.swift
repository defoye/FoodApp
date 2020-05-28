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
}

class InstructionsRequiredCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	@IBOutlet weak var instructionsRequiredLabel: UILabel!
	@IBOutlet weak var instructionsRequiredSwitch: UISwitch!
	
	weak var delegate: InstructionsRequiredCellDelegate?
	
	func configure(delegate: InstructionsRequiredCellDelegate) {
		super.awakeFromNib()
		instructionsRequiredSwitch.addTarget(self, action: #selector(switchSelectionChanged), for: .valueChanged)
		selectionStyle = .none
		instructionsRequiredLabel.text = "Instructions required"
		instructionsRequiredLabel.font = UIFont(name: "Avenir-Book", size: 16)
	
		instructionsRequiredSwitch.isOn = false
		
		tileView.backgroundColor = .clear
	}
	
	@objc func switchSelectionChanged() {
		delegate?.switchSelectionChanged(instructionsRequiredSwitch.isOn)
	}
}
