//
//  ButtonTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ id: String?)
}

public class ButtonTableViewCell: UITableViewCell {
    
    public class Model: Hashable {
        
        let uuid = UUID()
        var id: String?
        var insets: UIEdgeInsets = UIEdgeInsets()
        var buttonHeight: CGFloat?
        var title: String?
        var titleColor: UIColor?
        var tappedTitleColor: UIColor?
        var backgroundColor: UIColor?
        var cornerRadius: CGFloat?
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        public static func == (lhs: ButtonTableViewCell.Model, rhs: ButtonTableViewCell.Model) -> Bool {
            return lhs.uuid == rhs.uuid
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCellButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private weak var delegate: ButtonTableViewCellDelegate?
    private var id: String?
    
    func configure(_ model: Model, delegate: ButtonTableViewCellDelegate?) {
        setup(model.insets, model.buttonHeight)
        self.delegate = delegate
        self.id = model.id
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(model.titleColor, for: .normal)
        button.setTitleColor(model.tappedTitleColor, for: .selected)
        button.backgroundColor = model.backgroundColor
        button.layer.cornerRadius = model.cornerRadius ?? 5
    }
    
    private func setup(_ insets: UIEdgeInsets, _ buttonHeight: CGFloat?) {
        selectionStyle = .none
        contentView.addSubview(button)
        button.pin(to: contentView, insets: insets)
        button.heightAnchor.constraint(equalToConstant: buttonHeight ?? 40).isActive = true
    }
    
    @objc
    func buttonCellButtonTapped() {
        delegate?.buttonCellButtonTapped(id)
    }
}
