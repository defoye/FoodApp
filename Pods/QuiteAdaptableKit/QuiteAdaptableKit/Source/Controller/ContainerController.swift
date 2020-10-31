//
//  ContainerController.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

import UIKit

public protocol ContainerDelegate: class {
    func menuButtonTapped()
}

public protocol ContainerDelegator: UIViewController {
    var containerDelegate: ContainerDelegate? { get set }
}

/**
 Make container controller the root controller.
 */
public class ContainerController: UIViewController, ContainerDelegate {
    private weak var navBar: UINavigationController?
    private weak var containerDelegator: ContainerDelegator?
    private weak var slideInController: UIViewController?
    
    private var menuToggled: Bool = false {
        didSet {
            if oldValue {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.navBar?.view.frame.origin.x = 0
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.navBar?.view.frame.origin.x = (self.navBar?.view.frame.width ?? 120) - 120
                }, completion: nil)
            }
        }
    }
    
    public init(_ presenter: UINavigationController?, _ containerDelegator: ContainerDelegator? = nil, slideInController: UIViewController) {
        self.navBar = presenter
        self.containerDelegator = containerDelegator
        self.slideInController = slideInController
        
        super.init(nibName: nil, bundle: nil)
        
        initFinish()
    }
    
    private func initFinish() {
        containerDelegator?.containerDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllerViews()
    }
    
    public func menuButtonTapped() {
        menuToggled = !menuToggled
    }
    
    private func addViewControllerViews() {
        if let slideInView = slideInController?.view {
            view.addSubview(slideInView)
        }
        if let navBar = navBar {
            view.addSubview(navBar.view)
        }
    }
}
