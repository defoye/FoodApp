//
//  SignUpOptionCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import QuiteAdaptableKit

class SignUpOptionCell: UITableViewCell {
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    private lazy var verticalContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    private lazy var horizontalContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(borderView)
        borderView.addSubview(verticalContainerStackView)
        verticalContainerStackView.addArrangedSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(logoImageView)
        horizontalContainerStackView.addArrangedSubview(descriptionLabel)
        
        borderView.pin(to: contentView, insets: .init(top: 0, left: 70, bottom: -10, right: -70))
        verticalContainerStackView.pin(to: borderView, insets: .init(top: 10, left: 10, bottom: -10, right: -10))
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(image: UIImage?, description: String) {
        setup()
        logoImageView.image = image
        descriptionLabel.text = description
    }
}
