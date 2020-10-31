//
//  UITableView+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

extension UITableView {
    
    func configuredCell<T: UITableViewCell>(_ type: T.Type, identifier: String, indexPath: IndexPath? = nil, configurator: ((T) -> Void)) -> T {
        let cell: T
        
        if let indexPath = indexPath {
            if let dequeuedCell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
                cell = dequeuedCell
            } else {
                cell = T()
            }
        } else {
            if let dequeuedCell = self.dequeueReusableCell(withIdentifier: identifier) as? T {
                cell = dequeuedCell
            } else {
                cell = T()
            }
        }
        
        configurator(cell)
        
        return cell
    }
    
    func configuredCell<T: UITableViewCell>(_ type: T.Type, configurator: ((T) -> Void)) -> T {
        let cell = T()
        
        configurator(cell)
        
        return cell
    }
}

