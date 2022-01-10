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
        setupView()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let publisherNameView = BookDetailComponent(title: Text.Book.publisher)
    let publishedDateView = BookDetailComponent(title: Text.Book.publishedDate)
    let numberOfPageView = BookDetailComponent(title: Text.Book.numberOfPages)
    let languageView = BookDetailComponent(title: Text.Book.bookLanguage)
    let isbnView = BookDetailComponent(title: Text.Book.isbn)
    let priceView = BookDetailComponent(title: Text.Book.price)
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .viewControllerBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    
    private let topStackView = StackView(axis: .horizontal,
                                         distribution: .equalSpacing,
                                         spacing: 5)
    private let bottomStackView = StackView(axis: .horizontal,
                                            distribution: .fillEqually,
                                            spacing: 10)
    private let stackView = StackView(axis: .vertical,
                                      distribution: .fill,
                                      spacing: 15)
    
    // MARK: - Configure
    private func setupView() {
        self.roundView(radius: 10, backgroundColor: .cellBackgroundColor)
        topStackView.addArrangedSubview(publishedDateView)
        topStackView.addArrangedSubview(numberOfPageView)
        topStackView.addArrangedSubview(languageView)
        topStackView.addArrangedSubview(priceView)
        bottomStackView.addArrangedSubview(publisherNameView)
        bottomStackView.addArrangedSubview(isbnView)
        
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(separatorLine)
        stackView.addArrangedSubview(bottomStackView)
    }
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
