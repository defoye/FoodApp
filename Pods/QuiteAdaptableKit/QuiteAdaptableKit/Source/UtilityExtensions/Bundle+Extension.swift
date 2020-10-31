//
//  Bundle+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
