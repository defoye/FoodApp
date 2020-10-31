//
//  LoadingView.swift
//  QuiteAdaptableKit
//
//  Created by Ernest DeFoy on 10/29/20.
//

import UIKit

class LoadingView: UIView {
    
    let first = "Loading."
    let second = "Loading.."
    let third = "Loading..."
    
    let loadingLabel = UILabel()
    lazy var timer: Timer = {
        .scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let secondsSoFar = Int(Date().timeIntervalSince(timer.fireDate))
            var newText: String?
            if secondsSoFar % 3 == 0 {
                newText = self.first
            } else if secondsSoFar % 3 == 1 {
                newText = self.second
            } else {
                newText = self.third
            }
            
            DispatchQueue.main.async {
                self.loadingLabel.text = newText
            }
        }
    }()

    func start() {
        setup()
        timer.fire()
        isHidden = false
    }
    
    func stop() {
        timer.invalidate()
        isHidden = true
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.textAlignment = .center
        addSubview(loadingLabel)
        
        loadingLabel.pin(to: self)
        
        loadingLabel.font = UIFont.systemFont(ofSize: 20)
        
        loadingLabel.text = first
    }
}
