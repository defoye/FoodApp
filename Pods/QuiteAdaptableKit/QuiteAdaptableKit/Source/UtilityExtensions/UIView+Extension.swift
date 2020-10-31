//
//  UIView+Extension.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView, insets: UIEdgeInsets = UIEdgeInsets()) {
        if !superView.subviews.contains(self) {
            superView.addSubview(self)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: insets.bottom),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: insets.right)
        ])
    }
    
    func pin(to safeAreaLayoutGuide: UILayoutGuide, insets: UIEdgeInsets = UIEdgeInsets()) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: insets.bottom),
            leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: insets.right)
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
