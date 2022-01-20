//
//  ContactView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit

class ContactView: UIView {
    
    weak var delegate: ContactViewDelegate?
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        addButtonsAction()
        setStackViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let contactButton = Button(title: Text.ButtonTitle.contactUs,
                               icon: Images.ButtonIcon.feedBack,
                               imagePlacement: .leading,
                               tintColor: .appTintColor,
                               backgroundColor: .appTintColor)
    private let versionLabel = TextLabel(color: .label,
                                 maxLines: 1,
                                 alignment: .center,
                                 font: .regularFootnote)
    private let copyrightLabel = TextLabel(color: .secondaryLabel,
                                   maxLines: 1,
                                   alignment: .center,
                                   font: .lightFootnote)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 10)
    
    // MARK: - Configure
    private func setupView() {
        self.roundView(radius: 15, backgroundColor: .cellBackgroundColor)
        stackView.addArrangedSubview(contactButton)
        stackView.addArrangedSubview(versionLabel)
        stackView.addArrangedSubview(copyrightLabel)
        stackView.setCustomSpacing(40, after: contactButton)
        
        versionLabel.text = Text.Misc.appVersion + UIApplication.version
        copyrightLabel.text = "© Birkyboy 2021"
    }
    
    private func addButtonsAction() {
        contactButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.presentMailComposer()
        }), for: .touchUpInside)
    }
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
