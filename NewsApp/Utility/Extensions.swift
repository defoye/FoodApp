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

extension Date {
	
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

extension String {
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

extension UIView {
	
	@IBInspectable var viewCornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	func startShimmerAnimation() -> CALayer {
		let gradientLayer = CALayer(layer: layer)
		gradientLayer.backgroundColor = UIColor.white.cgColor
		gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width / 3, height: bounds.height)
		gradientLayer.opacity = 0.18
		layer.addSublayer(gradientLayer)

		let animation = CABasicAnimation(keyPath: "transform.translation.x")
		animation.duration = 1
		animation.fromValue = -frame.size.width
		animation.toValue = frame.size.width
		animation.repeatCount = .infinity
		gradientLayer.add(animation, forKey: "")
		subviews.forEach { $0.viewCornerRadius = 5; $0.backgroundColor = #colorLiteral(red: 0.9401247846, green: 0.9401247846, blue: 0.9401247846, alpha: 1) }
		
		return gradientLayer
	}
}

extension Dictionary {
	func merged(with dict: [Key: Value]) -> [Key: Value] {
		var newDict: [Key: Value] = [:]
		
		dict.forEach { (key, value) in
			newDict[key] = value
		}
		self.forEach { (key, value) in
			newDict[key] = value
		}
		
		return newDict
	}
}
