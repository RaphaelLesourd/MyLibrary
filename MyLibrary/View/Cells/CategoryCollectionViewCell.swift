//
//  CategoryCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    private let colorAlpha: CGFloat = 0.3
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = UIColor.appTintColor.withAlphaComponent(colorAlpha)
        roundView(radius: 12,
                  backgroundColor: .clear)
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private var categoryLabel = TextLabel(color: .appTintColor,
                                          alignment: .center,
                                          fontSize: 14,
                                          weight: .semibold)
    
    // MARK: - Configure
    func configure(with model: CategoryModel) {
        if let categoryName = model.name {
            categoryLabel.sizeToFit()
            categoryLabel.text = categoryName.uppercased()
        }
        if let color = model.color {
            let categoryColor = UIColor(hexString: color)
            contentView.backgroundColor = categoryColor.withAlphaComponent(colorAlpha)
            categoryLabel.textColor = categoryColor
        }
    }
    
    override func prepareForReuse() {
        categoryLabel.text = nil
        contentView.backgroundColor = UIColor.appTintColor.withAlphaComponent(colorAlpha)
        categoryLabel.textColor = .appTintColor
    }
}
// MARK: - Constraints
extension CategoryCollectionViewCell {
    private func setLabelConstraints() {
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
