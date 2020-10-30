//
//  ButtonTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

public class ButtonTableViewCell: UITableViewCell {
    
    public class Model {
        var insets: UIEdgeInsets = UIEdgeInsets()
        var buttonHeight: CGFloat?
        var title: String?
        var titleColor: UIColor?
        var tappedTitleColor: UIColor?
        var backgroundColor: UIColor?
        var cornerRadius: CGFloat?
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setup(_ insets: UIEdgeInsets, _ buttonHeight: CGFloat?) {
        selectionStyle = .none
        contentView.addSubview(button)
        button.pin(to: contentView, insets: insets)
        button.heightAnchor.constraint(equalToConstant: buttonHeight ?? 40).isActive = true
    }
    
    public func configure(_ model: Model) {
        setup(model.insets, model.buttonHeight)
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(model.titleColor, for: .normal)
        button.setTitleColor(model.tappedTitleColor, for: .selected)
        button.backgroundColor = model.backgroundColor
        button.layer.cornerRadius = model.cornerRadius ?? 5
    }
}
