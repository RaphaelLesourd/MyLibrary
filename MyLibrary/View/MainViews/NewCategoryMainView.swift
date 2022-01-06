//
//  CategoryCreationMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit

class NewCategoryMainView: UIView {
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setMainStackViewConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let categoryTextField = TextField(placeholder: Text.Placeholder.categoryName,
                                      keyBoardType: .default,
                                      returnKey: .done,
                                      correction: .yes,
                                      capitalization: .words)
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        layout.itemSize = CGSize(width: 30, height: 30)
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.register(ColorCollectionViewCell.self,
                            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        collection.alwaysBounceHorizontal = true
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return collection
    }()
    
    private let scrollView: UIScrollView = {
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
    private let titleLabel = TextLabel(fontSize: 27,
                                       weight: .bold)
    private let subtitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 4,
                                          fontSize: 16,
                                          weight: .regular)
    private let colorSectionTitleLabel = TextLabel(fontSize: 16,
                                                   weight: .regular)
    private let logoView = AppLogoView()
    private let mainStackView = StackView(axis: .vertical,
                                          spacing: 50)
    
    private func configure() {
        titleLabel.text = "New category"
        subtitleLabel.text = "Create a new category by giving a name and set a color."
        colorSectionTitleLabel.text = "Set category color"
    }
}

// MARK: - Constraints
extension NewCategoryMainView {
    
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setMainStackViewConstraints() {
        contentView.addSubview(mainStackView)
        let mainStackSubViews: [UIView] = [titleLabel,
                                           subtitleLabel,
                                           categoryTextField,
                                           colorSectionTitleLabel,
                                           collectionView,
                                           logoView]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(10, after: colorSectionTitleLabel)
        mainStackView.setCustomSpacing(80, after: collectionView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
