//
//  EmptyStateView.swift
//  MyLibrary
//
//  Created by Birkyboy on 01/12/2021.
//

import UIKit

class EmptyStateView: UIView {
    
    weak var delegate: EmptyStateViewDelegate?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview
    private let image: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .small)
        imageView.image = Images.TabBarIcon.booksIcon
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .appTintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    let titleLabel = TextLabel(color: .label,
                               maxLines: 0,
                               alignment: .center,
                               fontSize: 14,
                               weight: .medium)
    let doneButton = Button(title: Text.ButtonTitle.letsGo,
                            systemImage: Images.ButtonIcon.done,
                            imagePlacement: .leading, tintColor: .appTintColor,
                            backgroundColor: .appTintColor)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 20)
    
    // MARK: - Configure
    private func configure() {
        roundView(radius: 12, backgroundColor: .cellBackgroundColor)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(doneButton)
        doneButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.didTapButton()
        }), for: .touchUpInside)
    }
}

// MARK: - Constraints
extension EmptyStateView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            doneButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
