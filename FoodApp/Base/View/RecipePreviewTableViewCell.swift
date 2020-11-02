//
//  RecipePreviewTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/2/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class RecipePreviewTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "RecipePreviewTableViewCell"
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(_ item: FirebaseAPI.TopRecipesSearchResults.ResponseModel) {
        setup()
        recipeImageView.image = item.image
        headerLabel.text = item.title
        descriptionLabel.text = String(item.timeTitle)
    }
    
    func configure(_ item: RecipeDetailViewModel.SimilarRecipeItem) {
        setup()
        recipeImageView.image = item.image
        headerLabel.text = item.title
        descriptionLabel.text = item.timeTitle
    }
    
    private func setup() {
        selectionStyle = .none
        addSubviewsAndConstraints()
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(recipeImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(headerLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        
        horizontalStackView.pin(to: contentView, insets: .init(top: 0, left: 20, bottom: -20, right: -20))
        NSLayoutConstraint.activate([
            recipeImageView.heightAnchor.constraint(equalToConstant: 70),
            recipeImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}
