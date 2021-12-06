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
        setBackgroundImageConstraint()
        setBookCoverConstraints()
        setupMainstackView()
        setFavoriteButtonConstraints()
        bookCover.addShadow()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let activityIndicator = UIActivityIndicatorView()
    var editButton = UIBarButtonItem()
    var activityIndicatorButton = UIBarButtonItem()
    
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
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.55
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let bookCover = BookCover(frame: .zero)
    let titleLabel = TextLabel(maxLines: 5, alignment: .center, fontSize: 21, weight: .semibold)
    let authorLabel = TextLabel(maxLines: 3, alignment: .center, fontSize: 16, weight: .regular)
    let categoryiesLabel = TextLabel(color: .secondaryLabel, maxLines: 2, alignment: .center, fontSize: 13, weight: .medium)
    let ratingView = RatingView()
    let descriptionLabel = TextLabel(maxLines: 0, fontSize: 16, weight: .light)
    let purchaseDetailView = PurchaseView()
    let bookDetailView = BookDetailView()
    let isbnLabel = TextLabel(color: .secondaryLabel)
    let commentView = BookCardCommentView()
    let actionButton = ActionButton(title: "")
    let deleteBookButton: UIButton = {
        let button = UIButton()
        button.setTitle("Effacer ce livre", for: .normal)
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
        button.rounded(radius: 20, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
        let image = Images.favoriteImage?.withConfiguration(configuration)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    private let mainStackView = StackView(axis: .vertical, spacing: 30)
    
    override func layoutSubviews() {
        backgroundImage.addFadeGradient()
    }
}
// MARK: - Constraints
extension BookCardMainView {
    
    private func setBackgroundImageConstraint() {
        contentView.addSubview(backgroundImage)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -100),
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
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
        bookCover.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bookCover)
        NSLayoutConstraint.activate([
            bookCover.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bookCover.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bookCover.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            bookCover.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setFavoriteButtonConstraints() {
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.bottomAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: -10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40)
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
                                           commentView,
                                           actionButton,
                                           deleteBookButton]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(10, after: authorLabel)
        mainStackView.setCustomSpacing(15, after: categoryiesLabel)
        mainStackView.setCustomSpacing(50, after: ratingView)
        mainStackView.setCustomSpacing(20, after: bookDetailView)
        mainStackView.setCustomSpacing(5, after: deleteBookButton)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
