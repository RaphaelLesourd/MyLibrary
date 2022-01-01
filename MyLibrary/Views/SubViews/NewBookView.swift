//
//  NewBookView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit

class NewBookView: UIView {
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(appLogoView)
        stackView.addArrangedSubview(newBookButton)
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let newBookButton = Button(title: "New book",
                               systemImage: "",
                               imagePlacement: .leading,
                               tintColor: .appTintColor,
                               backgroundColor: .appTintColor)
    private let appLogoView: UIImageView = {
        let view = UIImageView()
        view.image = Images.TabBarIcon.booksIcon
        view.tintColor = .appTintColor
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()
    private let stackView = StackView(axis: .vertical,
                                      spacing: 20)
}
// MARK: - Constraints
extension NewBookView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
