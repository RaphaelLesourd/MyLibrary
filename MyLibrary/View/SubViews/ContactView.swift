//
//  ContactView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit

class ContactView: UIView {
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        roundView(radius: 15, backgroundColor: .cellBackgroundColor)
        stackView.addArrangedSubview(contactButton)
        stackView.addArrangedSubview(versionLabel)
        stackView.addArrangedSubview(copyrightLabel)
        stackView.setCustomSpacing(40, after: contactButton)
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let contactButton = Button(title: Text.ButtonTitle.contactUs,
                               icon: Images.ButtonIcon.feedBack,
                               imagePlacement: .leading,
                               tintColor: .appTintColor,
                               backgroundColor: .appTintColor)
    let versionLabel = TextLabel(color: .label,
                                 maxLines: 1,
                                 alignment: .center,
                                 font: .regularFootnote)
    let copyrightLabel = TextLabel(color: .secondaryLabel,
                                   maxLines: 1,
                                   alignment: .center,
                                   font: .lightFootnote)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 10)
}
// MARK: - Constraints
extension ContactView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
