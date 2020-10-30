//
//  LabelCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

public class LabelCell: UITableViewCell {
    
    public class Model: Hashable {
        
        let uuid = UUID()
        var textInsets: UIEdgeInsets = UIEdgeInsets()
        var text: String?
        var alignment: NSTextAlignment?
        var font: UIFont?
        var textColor: UIColor?
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        public static func == (lhs: LabelCell.Model, rhs: LabelCell.Model) -> Bool {
            return lhs.uuid == rhs.uuid
        }
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
    
    public func configure(_ model: Model) {
        setup(model.textInsets)
        
        label.text = model.text
        label.textAlignment = model.alignment ?? .center
        label.font = model.font
        label.textColor = model.textColor
    }
}
