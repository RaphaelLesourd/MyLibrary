//
//  EmptyStateView.swift
//  MyLibrary
//
//  Created by Birkyboy on 01/12/2021.
//

import UIKit

class EmptyStateView: UIView {
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(titleLabel)
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private let image: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .small)
        imageView.image = Images.TabBarIcon.booksIcon
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tertiaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    let titleLabel = TextLabel(color: .tertiaryLabel, maxLines: 3, alignment: .center, fontSize: 14, weight: .medium)
    private let stackView = StackView(axis: .vertical, spacing: 10)
}

// MARK: - Constraints
extension EmptyStateView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
