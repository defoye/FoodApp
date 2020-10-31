//
//  Int+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

public extension Int {
    
    func minutesIntToTimeString() -> String {
        let minutes = self
        let hours = Int(Double(minutes) / 60)
        let days = Int((Double(minutes) / 60) / 24)
            
        if days > 0 {
            if days == 1 {
                return "1 day"
            } else {
                return "\(days) days"
            }
        } else if hours > 0 {
            if hours == 1 {
                return "1 hour"
            } else {
                return "\(hours) hours"
            }
        } else {
            if minutes == 1 {
                return "1 minute"
            } else {
                return "\(minutes) minutes"
            }
        }
    }
}
