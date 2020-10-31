//
//  ContainerController.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

import UIKit

protocol ContainerDelegate: class {
    func menuButtonTapped()
}

protocol ContainerDelegator: UIViewController {
    var containerDelegate: ContainerDelegate? { get set }
}

class ContainerController: UIViewController, ContainerDelegate {
    private let navBar: UINavigationController
    private let containerDelegator: ContainerDelegator
    private let slideInController: UIViewController
    
    private var menuToggled: Bool = false {
        didSet {
            if oldValue {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.navBar.view.frame.origin.x = 0
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    self.navBar.view.frame.origin.x = self.navBar.view.frame.width - 120
                }, completion: nil)
            }
        }
    }
    
    init(_ presenter: UINavigationController, _ containerDelegator: ContainerDelegator, slideInController: UIViewController) {
        self.navBar = presenter
        self.containerDelegator = containerDelegator
        self.slideInController = slideInController
        
        super.init(nibName: nil, bundle: nil)
        
        initFinish()
    }
    
    private func initFinish() {
        containerDelegator.containerDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllerViews()
    }
    
    private func addViewControllerViews() {
        view.addSubview(slideInController.view)
        view.addSubview(navBar.view)
    }
    
    func menuButtonTapped() {
        menuToggled = !menuToggled
    }
}
