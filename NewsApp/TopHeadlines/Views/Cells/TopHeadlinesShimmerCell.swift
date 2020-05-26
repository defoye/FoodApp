//
//  TopHeadlinesShimmerCell.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/26/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class TopHeadlinesShimmerCell: UITableViewCell {
	
	@IBOutlet weak var tileView: UIView!
	
	var shimmerLayer: CALayer? {
		willSet {
			shimmerLayer?.removeFromSuperlayer()
		}
	}
	
	func configure() {
		super.awakeFromNib()
		selectionStyle = .none
		backgroundColor = .clear
		isUserInteractionEnabled = false
		shimmerLayer = tileView.startShimmerAnimation()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		layer.removeAllAnimations()
//		layer.sublayers?.removeAll()
	}
}
