//
//  Date+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

extension Date {
    func changedBy(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func asOfDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func timeSinceString(_ date: Date) -> String? {
        let interval = self - date
        
        let days = Int(interval / 86400)
        let hours = Int(interval.truncatingRemainder(dividingBy: 86400)) / 3600
        let minutes = Int(interval.truncatingRemainder(dividingBy: 3600)) / 60
        let seconds = Int((interval.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        if days > 0 {
            return "\(days)d ago"
        } else if hours > 0 {
            return "\(hours)h ago"
        } else if minutes > 0 {
            return "\(minutes)m ago"
        } else if seconds > 0 {
            return "\(seconds)s ago"
        } else {
            return nil
        }
    }

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
