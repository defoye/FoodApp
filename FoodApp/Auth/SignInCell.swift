//
//  SignInCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class SignInCell: UITableViewCell {
    
    lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account? Click here to sign in."
        label.textAlignment = .center
        return label
    }()
    
    private func setup() {
        selectionStyle = .none

        contentView.addSubview(signInLabel)
        
        signInLabel.pin(to: contentView, insets: .init(top: 20, left: 20, bottom: -20, right: -20))
    }
    
    func configure() {
        setup()
    }
}
