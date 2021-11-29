//
//  BookCardCommentView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/11/2021.
//

import Foundation
import UIKit

class BookCardCommentView: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
        titleView.titleLabel.text = "Commentaires des lecteurs"
        titleView.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.rounded(radius: 10, backgroundColor: UIColor.label.withAlphaComponent(0.05))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subview
    let titleView   = TitleViewView()
    private let stackView = StackView(axis: .vertical, spacing: 20)
}
// MARK: - Constraints
extension BookCardCommentView {
    private func setStackViewConstraints() {
        stackView.addArrangedSubview(titleView)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
