//
//  TextFieldTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/30/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    var textFieldValue: String? { get }
}

class TextFieldTableViewCell: UITableViewCell, TextFieldTableViewCellDelegate {
    
    class Model {
        var insets: UIEdgeInsets = .init(top: 20, left: 20, bottom: -20, right: -20)
        var placeholder: String?
        var font: UIFont?
        var textColor: UIColor?
        var returnKeyType: UIReturnKeyType?
        var textFieldPadding: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        var autocorrectionType: UITextAutocorrectionType?
        var autocapitalizationType: UITextAutocapitalizationType?
        var textContentType: UITextContentType?
        var keyboardType: UIKeyboardType?
        var isSecureTextEntry: Bool = false
        
        var labelText: String?
        var labelTextColor: UIColor?
        var labelFont: UIFont?
        var labelBottomInset: CGFloat?
    }
    
    private lazy var tileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var horizontalContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var verticalContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var searchTextFieldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    func configure(_ model: Model, _ inputAccessoryView: UIView? = nil) {
        setup()
        addSubviewAndConstraints(model.insets, model.labelBottomInset)
        searchTextFieldLabel.font = model.labelFont ?? UIFont(name: "Avenir-Book", size: 16)
        searchTextField.placeholder = model.placeholder
        searchTextField.textColor = model.textColor
        searchTextField.returnKeyType = model.returnKeyType ?? .done
        searchTextField.padding = model.textFieldPadding
        searchTextFieldLabel.text = model.labelText
        searchTextField.isSecureTextEntry = model.isSecureTextEntry
        if let autocorrectionType = model.autocorrectionType {
            searchTextField.autocorrectionType = autocorrectionType
        }
        if let autocapitalizationType = model.autocapitalizationType {
            searchTextField.autocapitalizationType = autocapitalizationType
        }
        if let textContentType = model.textContentType {
            searchTextField.textContentType = textContentType
        }
        if let inputAccessoryView = inputAccessoryView {
            searchTextField.inputAccessoryView = inputAccessoryView
        }
        if let keyboardType = model.keyboardType {
            searchTextField.keyboardType = keyboardType
        }
    }
    
    private func setup() {
        super.awakeFromNib()
        selectionStyle = .none
        searchTextField.delegate = self
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.layer.cornerRadius = 5.0
    }
    
    private func addSubviewAndConstraints(_ insets: UIEdgeInsets, _ labelBottomInset: CGFloat?) {
        contentView.addSubview(tileView)
        tileView.addSubview(horizontalContainerStackView)
        horizontalContainerStackView.addArrangedSubview(verticalContainerStackView)
        verticalContainerStackView.addArrangedSubview(searchTextFieldLabel)
        verticalContainerStackView.addArrangedSubview(searchTextField)
        
        tileView.pin(to: contentView, insets: insets)
        horizontalContainerStackView.pin(to: tileView)
        
        verticalContainerStackView.spacing = labelBottomInset ?? 10
    }
    
    var textFieldValue: String? {
        return searchTextField.text
    }
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
