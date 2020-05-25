//
//  ViewController.swift
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

protocol Storyboarded {
    static func instantiate(_ storyboardName: String) -> Self
}

extension Storyboarded where Self: UIViewController {
	static func instantiate(_ storyboardName: String) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: storyboardName, bundle: .current)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

class ViewController: UIViewController, Storyboarded {

	@IBOutlet weak var tableView: UITableView!
	
	let viewModel = ViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .orange
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		let nib = UINib.init(nibName: "Cell", bundle: .current)
		tableView.register(nib, forCellReuseIdentifier: "Cell")
//		tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
		
		viewModel.loadTopHeadlines {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(in: section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell, let item = viewModel.item(for: indexPath.row) {
			cell.configure(item)
			
			if let image = item.image {
				cell.setImage(image)
			} else {
				viewModel.loadImage(item.imageURL, indexPath.row) { image in
					DispatchQueue.main.async {
						self.tableView.beginUpdates()
						cell.setImage(image)
						self.tableView.endUpdates()
					}
				}
			}
			
			return cell
		}
		
		return UITableViewCell()
	}
	
	
}

class Cell: UITableViewCell {
	
	@IBOutlet weak var sourceLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
	@IBOutlet weak var articleImageViewHeight: NSLayoutConstraint!
	@IBOutlet weak var articleImageViewWidth: NSLayoutConstraint!
	func setup() {
		super.awakeFromNib()
		selectionStyle = .none
	}
	
	func configure(_ item: ViewModel.Item) {
		setup()
		
		sourceLabel.text = item.source
		sourceLabel.font = UIFont(name: "Avenir-Book", size: 24)
		titleLabel.text = item.title
		titleLabel.font = UIFont(name: "Avenir-Book", size: 16)

		if let author = item.author, !author.isEmpty {
			authorLabel.text = "by \(author)"
		} else {
			authorLabel.text = nil
		}
		authorLabel.font = UIFont(name: "Avenir-Book", size: 13)

		
		descriptionLabel.text = item.description
		descriptionLabel.font = UIFont(name: "Avenir-Book", size: 16)

		dateLabel.text = item.date
		dateLabel.font = UIFont(name: "Avenir-Book", size: 16)
	}
	
	func setImage(_ image: UIImage) {
		articleImageView.image = image
		contentView.layoutIfNeeded()

		let ratio = image.size.width / image.size.height
		let newHeight = self.articleImageView.frame.width / ratio
		articleImageViewHeight.constant = newHeight
	}
}
