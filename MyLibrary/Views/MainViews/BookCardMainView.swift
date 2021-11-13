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
        setFavoriteButtonConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical           = true
        scrollView.alwaysBounceHorizontal         = false
        scrollView.showsVerticalScrollIndicator   = false
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
    let bookCover              = BookCover(frame: .zero)
    let titleLabel             = TextLabel(maxLines: 2, alignment: .center, fontSize: 21, weight: .semibold)
    let authorLabel            = TextLabel(maxLines: 2, alignment: .center, fontSize: 16, weight: .regular)
    let categoryiesLabel       = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .center, fontSize: 13, weight: .medium)
    let ratingView             = RatingView()
    let descriptionLabel       = TextLabel(maxLines: 0, fontSize: 16, weight: .light)
    let purchaseDetailView     = PurchaseView()
    let currentResellPriceView = PurchaseView()
    let bookDetailView         = BookDetailView()
    let isbnLabel              = TextLabel(color: .secondaryLabel)
    let commentLabel           = TextLabel(maxLines: 0, alignment: .justified, fontSize: 16, weight: .light)
    let actionButton           = ActionButton(title: "")
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
    let favoriteButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .small)
        let image = Images.favoriteImage?.withConfiguration(configuration)
        button.setImage(image, for: .normal)
        button.transform = CGAffineTransform.identity.rotated(by: .pi/5)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
            bookCover.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            bookCover.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func setFavoriteButtonConstraints() {
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: bookCover.topAnchor, constant: -30),
            favoriteButton.leadingAnchor.constraint(equalTo: bookCover.trailingAnchor, constant: -20),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [titleLabel,
                                           authorLabel,
                                           categoryiesLabel,
                                           ratingView,
                                           descriptionLabel,
                                           bookDetailView,
                                           isbnLabel,
                                           purchaseDetailView,
                                           currentResellPriceView,
                                           commentLabel,
                                           actionButton,
                                           deleteBookButton]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        mainStackView.setCustomSpacing(2, after: titleLabel)
        mainStackView.setCustomSpacing(2, after: authorLabel)
        mainStackView.setCustomSpacing(15, after: categoryiesLabel)
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
