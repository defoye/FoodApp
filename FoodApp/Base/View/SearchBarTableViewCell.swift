//
//  SearchBarTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 11/8/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol SearchBarTableViewCellDelegate: class {
    var textFieldValue: String? { get }
}

class SearchBarTableViewCell: UITableViewCell, SearchBarTableViewCellDelegate {
    
    class Model: Hashable {
        let uuid = UUID()
        var placeholder: String?
        var insets: UIEdgeInsets = UIEdgeInsets()
        var backgroundImage: UIImage = UIImage()
        var searchBarStyle: UISearchBar.Style = .minimal
        var returnKeyType: UIReturnKeyType = .search
        var enablesReturnKeyAutomatically: Bool = true
        
        static func == (lhs: SearchBarTableViewCell.Model, rhs: SearchBarTableViewCell.Model) -> Bool {
            lhs.uuid == rhs.uuid
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    var textFieldValue: String? {
        return searchBar.text
    }
    
    func configure(_ model: Model) {
        setup(model)
        searchBar.placeholder = model.placeholder
        searchBar.backgroundImage = model.backgroundImage
        searchBar.searchBarStyle = model.searchBarStyle
        searchBar.enablesReturnKeyAutomatically = model.enablesReturnKeyAutomatically
        searchBar.returnKeyType = model.returnKeyType
    }
    
    private func setup(_ model: Model) {
        selectionStyle = .none
        
        contentView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: abs(model.insets.top) - 10),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -abs(model.insets.bottom) + 10),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: abs(model.insets.left) - 8),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -abs(model.insets.right) + 8)
        ])
    }
}

extension SearchBarTableViewCell: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
