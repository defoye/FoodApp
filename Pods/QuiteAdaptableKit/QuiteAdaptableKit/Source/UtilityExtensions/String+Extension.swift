//
//  String+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import Foundation

public extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let currentDate = dateFormatter.date(from: self) else {
            return nil
        }
        return currentDate
    }
    
    func formattedDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        if let date = self.toDate() {
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
