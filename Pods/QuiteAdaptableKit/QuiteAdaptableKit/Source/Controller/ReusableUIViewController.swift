//
//  ReusableUIViewController.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

class BaseUIViewController: UIViewController {
    
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
    
    private lazy var loadingView: UIView = {
        let loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .white
        let label = UILabel()
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Book", size: 24)
        label.textAlignment = .center
        label.pin(to: loadingView)
        return loadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

extension BaseUIViewController {
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.pin(to: view)
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            loadingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func removeLoadingView() {
        loadingView.removeFromSuperview()
    }
}
