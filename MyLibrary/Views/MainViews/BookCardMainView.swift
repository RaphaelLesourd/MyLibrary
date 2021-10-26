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
        setupBookDetailStackView()
        setupMainstackView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    // ScrollView
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
    let bookCover = BookCoverImageButton(frame: .zero)
    let titleLabel = TextLabel(maxLines: 2, alignment: .center, fontSize: 21, weight: .semibold)
    let authorLabel = TextLabel(alignment: .center, fontSize: 16, weight: .regular)
    let publisingDetailLabel = TextLabel(alignment: .center)
    let descriptionLabel = TextLabel(maxLines: 0, fontSize: 16, weight: .light)
    let numberOfPagesView = BookDetailElementView(iconSytemName: "book")
    let languageView = BookDetailElementView(iconSytemName: "doc.append")
    let purchaseDetailView = PurchaseView()
    let isbnLabel = TextLabel(color: .secondaryLabel)
    let commentLabel = TextLabel(maxLines: 0, alignment: .justified, fontSize: 16, weight: .light)
    let recommandButton = ActionButton(title: "Recommander cet oeuvre")
    let separatorLine: UIView = {
            let view = UIView()
            view.backgroundColor = .secondaryLabel
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    // MARK: stackViews
    private let bookDetailStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
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
        bookCover.isUserInteractionEnabled = true
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
    
    private func setupBookDetailStackView() {
        bookDetailStackView.addArrangedSubview(numberOfPagesView)
        bookDetailStackView.addArrangedSubview(languageView)
    }
    
    /// Setup the mainStackView which hold all the UI subviews.
    private func setupMainstackView() {
        contentView.addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [titleLabel,
                                           authorLabel,
                                           publisingDetailLabel,
                                           descriptionLabel,
                                           bookDetailStackView,
                                           separatorLine,
                                           purchaseDetailView,
                                           isbnLabel,
                                           commentLabel,
                                           recommandButton]
        mainStackSubViews.forEach {  mainStackView.addArrangedSubview($0) }
        mainStackView.setCustomSpacing(2, after: titleLabel)
        mainStackView.setCustomSpacing(2, after: authorLabel)
        mainStackView.setCustomSpacing(2, after: bookDetailStackView)
        mainStackView.setCustomSpacing(5, after: separatorLine)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: bookCover.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}
