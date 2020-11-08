//
//  RadioCell.swift
//  Expandable
//
//  Created by Ernest DeFoy on 11/6/20.
//

import UIKit

class RadioCellModel {
    var font: UIFont = .systemFont(ofSize: 13)
    var selectedFont: UIFont = .boldSystemFont(ofSize: 13)
    var backgroundColor: UIColor = .lightGray
    var selectedBackgroundColor: UIColor = .lightGray
    var textColor: UIColor = .black
    var selectedTextColor: UIColor = .black
    var cornerRadius: CGFloat? = 0
    var borderWidth: CGFloat = 3
}

class RadioCell: UICollectionViewCell {
    
    static let padding: UIEdgeInsets = .init(top: 10, left: 10, bottom: -10, right: -10)
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
        
    func configure(_ model: RadioCellModel, _ title: String) {
        titleLabel.text = title
        titleLabel.font = model.font
        titleLabel.textColor = model.textColor
        containerView.backgroundColor = model.backgroundColor
        setup()
        containerView.layoutIfNeeded()
        if let cornerRadius = model.cornerRadius {
            if containerView.frame.height / 2 < cornerRadius {
                containerView.layer.cornerRadius = containerView.frame.height / 2
            } else {
                containerView.layer.cornerRadius = cornerRadius
            }
        } else {
            containerView.layer.cornerRadius = (containerView.frame.height / 2)
        }
        containerView.layer.borderColor = model.textColor.cgColor
    }
    
    var isCellSelected: Bool = false {
        didSet {
            if isCellSelected {
                containerView.layer.borderWidth = 3
            } else {
                containerView.layer.borderWidth = 0
            }
        }
    }
    
    var textFieldValue: String? {
        return titleLabel.text
    }
    
    private func setup() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
             
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: RadioCell.padding.top)
        let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: RadioCell.padding.bottom)
        let leadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: RadioCell.padding.left)
        let trailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: RadioCell.padding.right)
        
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint
        ])
    }
    
    static func returnHeight(_ font: UIFont) -> CGFloat {
        return RadioCell.returnSize("g", font).height
    }
    
    static func returnSize(_ title: String, _ font: UIFont) -> CGSize {
        let cell = RadioCell(frame: .zero)
        let model = RadioCellModel()
        model.font = font
        cell.configure(model, title)
        var size = cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size = CGSize(width: size.width + abs(padding.left) + abs(padding.right), height: size.height + abs(padding.top) + abs(padding.bottom))
        if size.height >= size.width {
            let difference = min(size.height - size.width, size.height / 2)
            return CGSize(width: size.width + difference + 5, height: size.height)
        }
        return size
    }
    
//    //forces the system to do one layout pass
//    var isHeightCalculated: Bool = false
//
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        //Exhibit A - We need to cache our calculation to prevent a crash.
//        if !isHeightCalculated {
//            setNeedsLayout()
//            layoutIfNeeded()
//            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//            var newFrame = layoutAttributes.frame
//            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
//            layoutAttributes.frame = newFrame
//            isHeightCalculated = true
//        }
//        return layoutAttributes
//    }
}
