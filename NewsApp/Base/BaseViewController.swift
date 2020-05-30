//
//  BaseViewController.swift
//  NewsApp
//
//  Created by Ernest DeFoy on 5/30/20.
//  Copyright © 2020 Ernest DeFoy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
	
	/// Previous y coordinate of scrolling position
	private var previousOffset: CGFloat = 0
	/// Whether or not data has been fetched due to the scrolling threshold
	var nextPageCalled: Bool = false
	/// Whether or not current scroll position is range for fetching more data.
	private(set) var inScrollFetchRange: Bool = false
	/// Number of scrollView frame lengths. Used to compute scrolling threshold.
	var fetchDistanceMultiplier: CGFloat {
		return 1
	}
	
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
