//
//  BookDetailView.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import Foundation
import UIKit

class BookDetailView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackViewConstraints()
        self.rounded(radius: 10, backgroundColor: UIColor.label.withAlphaComponent(0.05))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let publisherNameView = BookDetailElementView(title: "Editeur")
    let publishedDateView = BookDetailElementView(title: "Publié")
    let numberOfPageView  = BookDetailElementView(title: "Pages")
    let languageView      = BookDetailElementView(title: "Langue")
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}
// MARK: - Constraints
extension BookDetailView {
   
    private func setStackViewConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(publishedDateView)
        stackView.addArrangedSubview(publisherNameView)
        stackView.addArrangedSubview(numberOfPageView)
        stackView.addArrangedSubview(languageView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
