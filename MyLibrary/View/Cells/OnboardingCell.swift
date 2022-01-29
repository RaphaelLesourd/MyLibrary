//
//  OnboardingCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.alpha = 0.8
        view.addShadow(opacity: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let titleLabel = TextLabel(color: .white,
                                       maxLines: 2,
                                       alignment: .center,
                                       font: .largeTitle)
    private let subtitleLabel = TextLabel(color: UIColor.white.withAlphaComponent(0.7),
                                          maxLines: 3,
                                          alignment: .center,
                                          font: .body)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 20)
    
    // MARK: - Configure
    func configure(with model: Onboarding) {
        imageView.image = model.image
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    private func setupView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }
}
// MARK: - Constraints
extension OnboardingCollectionViewCell {
    private func setConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
