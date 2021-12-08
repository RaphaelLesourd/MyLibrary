//
//  EmptyStateCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 03/12/2021.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .red
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private var titleLabel = TextLabel(color: .secondaryLabel, alignment: .center, fontSize: 14, weight: .semibold)
    
    // MARK: - Configure
    func configure(text: String?) {
        if let categoryName = text {
            titleLabel.sizeToFit()
            titleLabel.text = categoryName.uppercased()
        }
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
    }
}
// MARK: - Constraints
extension EmptyStateCollectionViewCell {    
    private func setLabelConstraints() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
