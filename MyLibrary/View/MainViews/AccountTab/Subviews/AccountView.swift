//
//  AccountView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit
import Lottie

class AccountView: UIView {
  
    weak var delegate: AccountViewDelegate?
    
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
    let signoutButton = Button(title: Text.ButtonTitle.signOut,
                               imagePlacement: .leading,
                               tintColor: .systemPurple,
                               backgroundColor: .systemPurple)
    let deleteButton = Button(title: Text.ButtonTitle.deletaAccount,
                              imagePlacement: .leading,
                              tintColor: .systemRed,
                              backgroundColor: .clear)
    private let stackView = StackView(axis: .vertical,
                                      spacing: 15)
    
    private func setupView() {
        stackView.addArrangedSubview(signoutButton)
        stackView.addArrangedSubview(deleteButton)
    }
    
    private func addButtonsAction() {
        signoutButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.presentSignOutAlert()
        }), for: .touchUpInside)
        deleteButton.addAction(UIAction(handler: { [weak self] _ in
            self?.delegate?.deleteAccount()
        }), for: .touchUpInside)
    }
}
// MARK: - Constraints
extension AccountView {
    private func setStackViewConstraints() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
