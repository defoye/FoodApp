//
//  UICollectionView+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

extension UICollectionView {
    func reloadDataOnMain() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
