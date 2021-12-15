//
//  BookDetailView.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import UIKit

class BookDetailView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(publishedDateView)
        stackView.addArrangedSubview(publisherNameView)
        stackView.addArrangedSubview(numberOfPageView)
        stackView.addArrangedSubview(languageView)
        
        setStackViewConstraints()
        self.rounded(radius: 10, backgroundColor: UIColor.label.withAlphaComponent(0.05))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let publisherNameView = BookDetailElementView(title: Text.Book.publisher)
    let publishedDateView = BookDetailElementView(title: Text.Book.publishedDate)
    let numberOfPageView = BookDetailElementView(title: Text.Book.numberOfPages)
    let languageView = BookDetailElementView(title: Text.Book.bookLanguage)
    private let stackView = StackView(axis: .horizontal, distribution: .fillProportionally, spacing: 10)
}
// MARK: - Constraints
extension BookDetailView {
   
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
