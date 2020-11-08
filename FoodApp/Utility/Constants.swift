//
//  Constants.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class Constants {
    
    enum Images: String {
        case apple_logo
        case google_logo
        case facebook_logo
        case email_logo
        case cooking_book
        case home
        case info
        case heart
        case error
        
        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
    
    enum Ints: Int {
        case homeTopRecipesCount = 3
    }
    
    enum CGFloats: CGFloat {
        case cornerRadius1 = 5
    }
    
    enum Eligibility {
        case useOnlineData
        
        var flag: Bool {
            switch self {
            case .useOnlineData:
                return false
            }
        }
    }
    
    enum Colors {
        case separator
        
        var color: UIColor {
            switch self {
            case .separator:
                return .lightGray
            }
        }
    }
}
