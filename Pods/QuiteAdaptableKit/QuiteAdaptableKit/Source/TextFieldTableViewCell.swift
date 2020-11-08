//
//  TextFieldTableViewCell.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/31/20.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    var textFieldValue: String? { get }
}

class TextFieldTableViewCell: UITableViewCell, TextFieldTableViewCellDelegate {
    
    class Model: Hashable {
        
        enum BorderStyle {
            case bottomLine
            case box
        }
        
        let uuid = UUID()
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
        var clearButtonMode: UITextField.ViewMode?
        
        // Border
        var borderStyle: BorderStyle = .bottomLine
        var borderWidth: CGFloat = 1.0
        var borderColor: UIColor = .darkGray
        var cornerRadius: CGFloat = 5.0
        
        var labelText: String?
        var labelTextColor: UIColor?
        var labelFont: UIFont?
        var labelBottomInset: CGFloat?
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        public static func == (lhs: Model, rhs: Model) -> Bool {
            return lhs.uuid == rhs.uuid
        }
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
        if let clearButtonMode = model.clearButtonMode {
            searchTextField.clearButtonMode = clearButtonMode
        }
        searchTextField.layoutIfNeeded()
        switch model.borderStyle {
        case .bottomLine:
            searchTextField.addBottomBorder(model.borderWidth, color: model.borderColor)
        case .box:
            searchTextField.layer.borderWidth = model.borderWidth
            searchTextField.layer.borderColor = model.borderColor.cgColor
            searchTextField.layer.cornerRadius = model.cornerRadius
        }
    }
    
    private func setup() {
        selectionStyle = .none
        searchTextField.delegate = self
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

extension UITextField {
    func addBottomBorder(_ height: CGFloat, color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height)
        bottomLine.backgroundColor = color.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}

extension TextFieldTableViewCell {
    
    class CustomTextField: UITextField {

        var padding: UIEdgeInsets?
        
        init(padding: UIEdgeInsets? = nil) {
            self.padding = padding
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding ?? UIEdgeInsets())
        }
        
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding ?? UIEdgeInsets())
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding ?? UIEdgeInsets())
        }
    }
}
