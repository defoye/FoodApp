//
//  Constants.swift
//  FoodApp
//
//  Created by Ernest DeFoy on 10/29/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class Constants {
    
    enum Images {
        case apple_logo
        case google_logo
        case facebook_logo
        case email_logo
        
        var name: String {
            switch self {
            case .apple_logo:
                return "apple_logo"
            case .google_logo:
                return "google_logo"
            case .facebook_logo:
                return "facebook_logo"
            case .email_logo:
                return "email_logo"
            }
        }
        
        var image: UIImage? {
            return UIImage(named: self.name)
        }
    }
    
    enum Ints: Int {
        case homeTopRecipesCount = 3
    }
    
    enum CGFloats: CGFloat {
        case cornerRadius1 = 5
    }
}
