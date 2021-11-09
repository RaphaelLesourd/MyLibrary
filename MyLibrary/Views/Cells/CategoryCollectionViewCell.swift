//
//  CategoryCollectionViewCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 24/10/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .red
        rounded(radius: 10, backgroundColor: UIColor.label.withAlphaComponent(0.05))
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var categoryLabel = TextLabel(alignment: .center, fontSize: 16, weight: .medium)
    
    override func prepareForReuse() {
        categoryLabel.text = nil
    }
    
    func configure(text: String?) {
        categoryLabel.text = text ?? ""
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
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
