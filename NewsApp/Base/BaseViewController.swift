//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/30/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	
	private var previousOffset: CGFloat = 0
	var nextPageCalled: Bool = false
	var inScrollFetchRange: Bool = false
	var fetchDistanceMultiplier: CGFloat = 1
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let contentHeight = scrollView.contentSize.height
		let frameHeight = scrollView.frame.height
		let currentY = scrollView.contentOffset.y
		let newContentScrollThreshold = contentHeight - currentY <= frameHeight * fetchDistanceMultiplier
		let isScrollingDown = currentY - previousOffset > 0
		inScrollFetchRange = newContentScrollThreshold
							 && isScrollingDown
							 && !nextPageCalled
		
		previousOffset = currentY
	}
}
