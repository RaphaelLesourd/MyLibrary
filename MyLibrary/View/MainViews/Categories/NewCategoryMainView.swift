//
//  CategoryCreationMainView.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/01/2022.
//

import UIKit

class NewCategoryMainView: UIView {
    
    weak var delegate: NewCategoryViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.roundView(radius: 12, backgroundColor: .cellBackgroundColor)
        
        setScrollViewConstraints()
        setMainStackViewConstraints()
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
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 27
        layout.itemSize = CGSize(width: 40, height: 40)
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        collection.register(ColorCollectionViewCell.self,
                            forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        collection.alwaysBounceVertical = true
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.heightAnchor.constraint(equalToConstant: 350).isActive = true
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
    private let titleLabel = TextLabel(font: .controllerTitle)
    private let subtitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 4,
                                          font: .subtitle)
    private let colorSectionTitleLabel = TextLabel(font: .mediumSemiBoldTitle)
    private let saveButton = Button(title: Text.ButtonTitle.save,
                                    imagePlacement: .leading,
                                    tintColor: .appTintColor,
                                    backgroundColor: .appTintColor)
    private let mainStackView = StackView(axis: .vertical,
                                          spacing: 20)
   
    // MARK: - Configure
    func updateBackgroundColor(with colorHex: String) {
        contentView.backgroundColor = UIColor(hexString: colorHex).withAlphaComponent(0.05)
    }
    
    func configure(for editing: Bool) {
        titleLabel.text = editing ? Text.ControllerTitle.editCategoryTitle : Text.ControllerTitle.newCategoryTitle
        subtitleLabel.text = editing ? Text.ControllerTitle.editCategorySubtitle : Text.ControllerTitle.newCategorySubtitle
        colorSectionTitleLabel.text = Text.SectionTitle.categoryColor
       
        let buttonTitle = editing ? Text.ButtonTitle.update : Text.ButtonTitle.save
        saveButton.configureButton(with: buttonTitle, systemImage: Images.ButtonIcon.done)
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.saveCategory()
        }), for: .touchUpInside)
    }
}

// MARK: - Constraints
extension NewCategoryMainView {
    
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,  constant: -16),
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
                                           saveButton]
        mainStackSubViews.forEach { mainStackView.addArrangedSubview($0) }
        
        mainStackView.setCustomSpacing(5, after: titleLabel)
        mainStackView.setCustomSpacing(80, after: categoryTextField)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
