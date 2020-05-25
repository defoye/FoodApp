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
	}
	
	func configure(_ item: NewsApi.Article) {
		setup()
		
		sourceLabel.text = item.source?.name
		titleLabel.text = item.title
		authorLabel.text = item.author
		
		downloadImage(from: item.urlToImage ?? "") { image in
			DispatchQueue.main.async {
				let ratio = image.size.width / image.size.height
				self.articleImageView.layoutIfNeeded()
				let newHeight = self.articleImageView.frame.width / ratio
				self.articleImageViewHeight.constant = newHeight
				self.contentView.layoutIfNeeded()
			}
		}
		
		descriptionLabel.text = item.articleDescription
		dateLabel.text = item.publishedAt
	}
	
	func downloadImage(_ url: URL, contentMode: ContentMode, _ completion: @escaping ((UIImage) -> Void)) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
			completion(image)
        }.resume()
	}
	
    func downloadImage(from link: String, contentMode mode: ContentMode = .scaleAspectFit, _ completion: @escaping ((UIImage) -> Void)) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloadImage(url, contentMode: mode, completion)
    }
}
