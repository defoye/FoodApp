//
//  SeparatorTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/8/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class SeparatorTableViewCell: UITableViewCell {
    
    class Model: Hashable {
        let uuid = UUID()
        var insets: UIEdgeInsets = UIEdgeInsets()
        var backgroundColor: UIColor?
        
        static func == (lhs: SeparatorTableViewCell.Model, rhs: SeparatorTableViewCell.Model) -> Bool {
            lhs.uuid == rhs.uuid
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
    }
    
    private lazy var separatorView = UIView()
    
    func configure(_ model: Model) {
        setup(model)
        if let backgroundColor = model.backgroundColor {
            separatorView.backgroundColor = backgroundColor
        }
    }
    
    func setup(_ model: Model) {
        selectionStyle = .none
        contentView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.pin(to: contentView, insets: model.insets)
    }
}
