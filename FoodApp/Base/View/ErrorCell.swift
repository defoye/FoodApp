//
//  ErrorCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/5/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class ErrorCell: UITableViewCell {
        
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    private let errorImageView = UIImageView(image: Constants.Images.error.image)
    private let label = UILabel()
    
    func configure(_ text: String, _ insets: UIEdgeInsets = UIEdgeInsets()) {
        setup(insets)
        label.text = text
    }
    
    private func setup(_ insets: UIEdgeInsets) {
        contentView.addSubview(stackView)
        stackView.pin(to: contentView, insets: insets)
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(label)
        NSLayoutConstraint.activate([
            errorImageView.heightAnchor.constraint(equalToConstant: 40),
            errorImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
