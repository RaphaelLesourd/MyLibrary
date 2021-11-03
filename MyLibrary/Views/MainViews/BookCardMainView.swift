//
//  BookCardMainView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation
import UIKit

class BookCardMainView: UIView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setBookCoverConstraints()
        setupMainstackView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// Create the contentView in the scrollView that will contain all the UI elements.
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // BookCard elements
    let bookCover: BookCover = {
        let image = BookCover(frame: .zero)
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    let titleLabel = TextLabel(maxLines: 2, alignment: .center, fontSize: 21, weight: .semibold)
    let authorLabel = TextLabel(alignment: .center, fontSize: 16, weight: .regular)
    let categoryiesLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .center, fontSize: 13, weight: .medium)
    let descriptionLabel = TextLabel(maxLines: 0, fontSize: 16, weight: .light)
    let purchaseDetailView = PurchaseView()
    let currentResellPriceView = PurchaseView()
    let bookDetailView = BookDetailView()
    let isbnLabel = TextLabel(color: .secondaryLabel)
    let commentLabel = TextLabel(maxLines: 0, alignment: .justified, fontSize: 16, weight: .light)
    let actionButton = ActionButton(title: "Recommander")
    let deleteBookButton: UIButton = {
        let button = UIButton()
        button.setTitle("Effacer ce livre de votre bibliothèque", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return button
    }()
    
    let separatorLine: UIView = {
            let view = UIView()
            view.backgroundColor = .secondaryLabel
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    private let mainStackView = StackView(axis: .vertical, spacing: 30)
}
// MARK: - Constraints
extension BookCardMainView {
    
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setBookCoverConstraints() {
        bookCover.addShadow()
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bookCover)
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookCover.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookCover.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            bookCover.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [titleLabel,
                                           authorLabel,
                                           categoryiesLabel,
                                           descriptionLabel,
                                           bookDetailView,
                                           isbnLabel,
                                           purchaseDetailView,
                                           currentResellPriceView,
                                           commentLabel,
                                           actionButton,
                                           deleteBookButton]
        mainStackSubViews.forEach {  mainStackView.addArrangedSubview($0) }
        mainStackView.setCustomSpacing(2, after: titleLabel)
        mainStackView.setCustomSpacing(2, after: authorLabel)
        mainStackView.setCustomSpacing(5, after: purchaseDetailView)
        mainStackView.setCustomSpacing(5, after: deleteBookButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
