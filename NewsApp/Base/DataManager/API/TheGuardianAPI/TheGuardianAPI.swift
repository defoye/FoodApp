//
//  TheGuardianAPI.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum TheGuardianAPI {
	case editions
	
	var url: String {
		switch self {
		case .editions:
			return "https://content.guardianapis.com/editions"
		}
	}
	
	var key: String {
		return "2ddfc191-3af8-464f-971f-f1074c468cd7"
	}
}
