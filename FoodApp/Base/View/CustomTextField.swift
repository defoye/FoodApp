//
//  CustomTextField.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/30/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

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
