//
//  HeaderSupplementaryView.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setStackViewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    // MARK: - Subviews
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.ButtonTitle.seeAll, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .subtitle
        return button
    }()
    
    private let titleLabel = TextLabel(font: .sectionTitle)
    private let stackView = StackView(axis: .horizontal,
                                      spacing: 0)
   
    // MARK: - Configure
    func configure(with title: String, buttonTitle: String) {
        titleLabel.text = title
        moreButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func setupView() {
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(moreButton)
    }
}
// MARK: - Constraints
extension HeaderSupplementaryView {
    private func setStackViewConstrainsts() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
