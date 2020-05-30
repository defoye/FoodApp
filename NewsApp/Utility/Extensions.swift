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
	
	func pin(to superView: UIView, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leadingInset: CGFloat = 0, trailingInset: CGFloat = 0) {
		if !superView.subviews.contains(self) {
			superView.addSubview(self)
		}
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: superView.topAnchor, constant: topInset),
			bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: bottomInset),
			leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leadingInset),
			trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailingInset)
		])
	}
	
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

extension Int {
	
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

extension Double {
	
	struct Rational {
		let numerator : Int
		let denominator: Int

		init(numerator: Int, denominator: Int) {
			self.numerator = numerator
			self.denominator = denominator
		}

		init(approximating x0: Double, withPrecision eps: Double = 1.0E-6) {
			var x = x0
			var a = x.rounded(.down)
			var (h1, k1, h, k) = (1, 0, Int(a), 1)

			while x - a > eps * Double(k) * Double(k) {
				x = 1.0/(x - a)
				a = x.rounded(.down)
				(h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
			}
			self.init(numerator: h, denominator: k)
		}
	}
	
	func roundedFractionString() -> String {
		let rational = Rational(approximating: self)
		
		if rational.numerator == rational.denominator {
			return String(Int(self))
		} else if rational.denominator == 1 {
			return String(rational.numerator)
		}
		
		return "\(rational.numerator)/\(rational.denominator)"
	}
}
