//
//  BookDetailElementView.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class BookDetailComponent: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        titleLabel.text = title.capitalized
    }
    
    // MARK: - Subviews
    let infoLabel = TextLabel(alignment: .center, fontSize: 14, weight: .light)
    private let titleLabel = TextLabel(color: .secondaryLabel, alignment: .center, fontSize: 12, weight: .light)
    private let stackView = StackView(axis: .vertical, distribution: .fillProportionally, spacing: 2)

}
// MARK: - Constraints
extension BookDetailComponent {
    private func setConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
