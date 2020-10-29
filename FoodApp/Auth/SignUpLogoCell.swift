//
//  SignUpLogoCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class SignUpLogoCell: UITableViewCell {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FoodApp"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 50)
        return label
    }()
    
    func setup() {
        selectionStyle = .none

        contentView.addSubview(logoImageView)
        
        logoLabel.pin(to: contentView, insets: .init(top: 20, left: 20, bottom: -20, right: -20))
        
//        NSLayoutConstraint.activate([
//            logoImageView.heightAnchor.constraint(equalToConstant: 40),
//            logoImageView.widthAnchor.constraint(equalToConstant: 40),
//            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            logoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//        ])
    }
    
    func configure(image: UIImage?) {
        setup()
        logoImageView.image = image
    }
}
