//
//  Extensions.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/25/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

extension Bundle {
	static var current: Bundle {
		class __ { }
		return Bundle(for: __.self)
	}
}
