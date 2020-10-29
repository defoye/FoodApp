//
//  EdamamAPI.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import Foundation

enum EdamamAPI {
    enum Recipes {
        case search
        
        var url: String {
            switch self {
            case .search:
                return "https://api.edamam.com/search"
            }
        }
    }
    
    static var id: String {
        return "98266d28"
    }
    
    static var key: String {
        return "ab02af3f2ad2aa8c368090e2a8d5dd2c"
    }
}
