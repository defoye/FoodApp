//
//  RadioGroupTableViewCell.swift
//  Expandable
//
//  Created by Ernest DeFoy on 11/6/20.
//

import UIKit

class RadioGroupModel: Hashable {
    
    let uuid = UUID()
    
    var minimumLayoutLineSpacing: CGFloat = 20
    var minimumLayoutInteritemSpacing: CGFloat = 10
    var maxValuesPerRow: Int = 3
    var insets: UIEdgeInsets = UIEdgeInsets()
    var maxCellWidth: CGFloat?
    var isCollectionCentered: Bool = false
    
    var values: [String] = []
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    var backgroundColor: UIColor = .white
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        if isCollectionCentered {
            layout = CenterAlignedCollectionViewFlowLayout()
        }
        layout.minimumLineSpacing = minimumLayoutLineSpacing
        layout.minimumInteritemSpacing = minimumLayoutInteritemSpacing
        layout.scrollDirection = scrollDirection
        layout.sectionInset = insets
        return layout
    }()
    
    var radioCellModel: RadioCellModel = RadioCellModel()
    
    static func == (lhs: RadioGroupModel, rhs: RadioGroupModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

public class RadioGroupTableViewCell: UITableViewCell {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: model.flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        if model.flowLayout.scrollDirection == .horizontal {
            collectionView.isScrollEnabled = true
        } else {
            collectionView.isScrollEnabled = true
        }
        collectionView.register(RadioCell.self, forCellWithReuseIdentifier: "RadioCell")
        return collectionView
    }()
    
    
    private lazy var valueSizes: [CGSize] = {
        let sizeInformation = RadioGroupTableViewCell.computeSizes(model, frameWidth)
        
        return sizeInformation.sizes
    }()
    
    private var model: RadioGroupModel!
    private var frameWidth: CGFloat!
    private var selectedCell: RadioCell?
    
    var selectedValue: String?
    
    func configure(_ model: RadioGroupModel, _ frameWidth: CGFloat) {
        self.model = model
        self.frameWidth = frameWidth - abs(model.insets.left) - abs(model.insets.right)
        setup(model)
    }
    
    private func setup(_ model: RadioGroupModel) {
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: RadioGroupTableViewCell.returnHeight(model, frameWidth))
        ])
        collectionView.backgroundColor = model.backgroundColor
    }
}

extension RadioGroupTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = model?.values.count ?? 0
        
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioCell", for: indexPath) as? RadioCell, let model = model {
            let title = model.values[indexPath.row]
            cell.configure(model.radioCellModel, title)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let size = valueSizes[safe: indexPath.row] else {
            return UICollectionViewFlowLayout.automaticSize
        }
        
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RadioCell else {
            return
        }
        if cell == selectedCell {
            cell.isCellSelected = !cell.isCellSelected
            if !cell.isCellSelected {
                selectedCell = nil
            }
        } else {
            cell.isCellSelected = !cell.isCellSelected
            selectedCell?.isCellSelected = false
            if cell.isCellSelected {
                selectedCell = cell
            }
        }
        selectedValue = selectedCell?.textFieldValue
    }
}

extension RadioGroupTableViewCell {
    
    static func returnHeight(_ model: RadioGroupModel, _ frameWidth: CGFloat) -> CGFloat {
        if model.flowLayout.scrollDirection == .horizontal {
            return RadioCell.returnHeight(model.radioCellModel.font) + abs(RadioCell.padding.top) + abs(RadioCell.padding.bottom)
        } else {
            let sizeInformation = RadioGroupTableViewCell.computeSizes(model, frameWidth)
            let numRows = CGFloat(sizeInformation.numberOfRows)
            var height = (numRows * RadioCell.returnHeight(model.radioCellModel.font)) + ((numRows - 1) * model.minimumLayoutLineSpacing)
            height += abs(model.insets.top) + abs(model.insets.bottom)
            
            return height
        }
    }
    
    struct SizeInformation {
        let sizes: [CGSize]
        let numberOfRows: Int
    }
    
    static func computeSizes(_ model: RadioGroupModel, _ frameWidth: CGFloat) -> SizeInformation {
        let sizes = model.values.map { value -> CGSize in
            return RadioCell.returnSize(value, model.radioCellModel.font)
        }
        
        var totalWidth = sizes.reduce(0) { (resultSoFar, size) -> CGFloat in
            return resultSoFar + size.width
        }
        totalWidth += model.minimumLayoutInteritemSpacing * CGFloat(sizes.count - 1)
        let weights = sizes.map { size -> CGFloat in
            return size.width / totalWidth
        }
        let difference = totalWidth - frameWidth
        
        let extraPaddings = weights.map { weight -> CGFloat in
            return (weight * difference) - model.minimumLayoutInteritemSpacing
        }
        
        let computedSizes = zip(sizes, extraPaddings).map { (size, extraPadding) -> CGSize in
            return CGSize(width: size.width + extraPadding, height: size.height)
        }
                        
        if model.scrollDirection == .vertical {
            var valueArrays: [CGSize] = []
            var tmpSizes: [CGSize] = []
            var numberOfRows: Int = 0
            
            computedSizes.forEach { size in
                let combinedWidth = computeCombinedWidth(tmpSizes, model.minimumLayoutInteritemSpacing)
                let nextCombinedWidth = size.width + combinedWidth

                if nextCombinedWidth > frameWidth || tmpSizes.count >= model.maxValuesPerRow {
                    valueArrays += sizesWithExtraPadding(frameWidth, combinedWidth, tmpSizes, model.maxCellWidth)
                    
                    tmpSizes = []
                    numberOfRows += 1
                }
                
                tmpSizes.append(size)
            }
            
            let combinedWidth = computeCombinedWidth(tmpSizes, model.minimumLayoutInteritemSpacing)
            let verticalComputedSizes = valueArrays + sizesWithExtraPadding(frameWidth, combinedWidth, tmpSizes, model.maxCellWidth)
            if tmpSizes.count > 0 {
                numberOfRows += 1
            }
            
            return SizeInformation(sizes: verticalComputedSizes, numberOfRows: numberOfRows)
        } else {
            return SizeInformation(sizes: computedSizes, numberOfRows: 1)
        }
    }
    
    private static func computeCombinedWidth(_ sizes: [CGSize], _ minimumSpacing: CGFloat) -> CGFloat {
        let widths = sizes.map { $0.width }
        let combinedWidth = widths.reduce(0) { $0 + $1 } + (minimumSpacing * CGFloat(CGFloat(sizes.count) - 1.0))
        
        return combinedWidth
    }
}

extension RadioGroupTableViewCell {
    
    private static func sizesWithExtraPadding(_ frameWidth: CGFloat, _ combinedWidth: CGFloat, _ tmpSizes: [CGSize], _ maxWidth: CGFloat?) -> [CGSize] {
        let tmpWidths = tmpSizes.map { $0.width }
        let difference = frameWidth - combinedWidth
        let combinedWeights = computeWeights(tmpWidths, combinedWidth)
        let extraPaddings = combinedWeights.map { $0 * difference }
        
        var computedSizes = zip(tmpSizes, extraPaddings).map { (size, extraPadding) -> CGSize in
            return CGSize(width: size.width + extraPadding, height: size.height)
        }
        
        if let maxWidth = maxWidth {
            computedSizes = computedSizes.map({ size -> CGSize in
                return CGSize(width: min(size.width, maxWidth), height: size.height)
            })
        }
        
        return computedSizes
    }
    
    private static func computeWeights(_ widths: [CGFloat], _ combinedWidth: CGFloat) -> [CGFloat] {
        let computedWeights = widths.map { width -> CGFloat in
            return width / combinedWidth
        }
        
        return computedWeights
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
