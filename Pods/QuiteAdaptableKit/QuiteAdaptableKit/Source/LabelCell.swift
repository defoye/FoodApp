//
//  LabelCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    
    class Model {
        var textInsets: UIEdgeInsets = UIEdgeInsets()
        var text: String?
        var alignment: NSTextAlignment?
        var font: UIFont?
        var textColor: UIColor?
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setup(_ insets: UIEdgeInsets) {
        self.selectionStyle = .none
        contentView.addSubview(label)
        label.pin(to: contentView, insets: insets)
    }
    
    func configure(_ model: Model) {
        setup(model.textInsets)
        
        label.text = model.text
        label.textAlignment = model.alignment ?? .center
        label.font = model.font
        label.textColor = model.textColor
    }
}
