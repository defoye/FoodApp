//
//  BlankTableViewCell.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/31/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class BlankTableViewCell: UITableViewCell {
    
    class SetupModel: Hashable {
        let uuid = UUID()
        var selectionStyle: UITableViewCell.SelectionStyle = .none
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        public static func == (lhs: SetupModel, rhs: SetupModel) -> Bool {
            return lhs.uuid == rhs.uuid
        }
    }
    
    class ViewModel: Hashable {
        let uuid = UUID()
        var viewInsets: UIEdgeInsets = UIEdgeInsets()
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }
        
        public static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            return lhs.uuid == rhs.uuid
        }
    }
    
    func configure(_ view: UIView, setupModel: SetupModel = SetupModel(), viewModel: ViewModel) {
        setup(setupModel)
        
        contentView.addSubview(view)
        view.pin(to: contentView, insets: viewModel.viewInsets)
    }
    
    private func setup(_ model: SetupModel) {
        selectionStyle = model.selectionStyle
    }
}
