//
//  IpadSideBarView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit

class AccountTabMainView: UIView {
   
    weak var delegate: AccountViewDelegate?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(accountView)
        stackView.addArrangedSubview(contactView)
        stackView.addArrangedSubview(newBookView)
        stackView.setCustomSpacing(40, after: contactView)
        setScrollViewConstraints()
        setStackViewConstraints()
        setTargets()
        displayAppInfos()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let accountView = AccountView()
    let contactView = ContactView()
    let newBookView = AppLogoView()
    
    let activityIndicator = UIActivityIndicatorView()
    
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
    private let stackView = StackView(axis: .vertical,
                                      spacing: 20)
    
    // MARK: - configuration
    private func configureUI() {
        let device = UIDevice.current.userInterfaceIdiom
        newBookView.isHidden = device != .pad
    }
    
    private func displayAppInfos() {
        contactView.versionLabel.text = Text.Misc.appVersion + UIApplication.version
        contactView.copyrightLabel.text = "© Birkyboy 2021"
     }
   
    // MARK: - Targets
    private func setTargets() {
        accountView.profileImageButton.addTarget(self, action: #selector(updateProfileImage), for: .touchUpInside)
        accountView.signoutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        accountView.deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        contactView.contactButton.addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
    }
    
    @objc private func updateProfileImage() {
        delegate?.presentImagePicker()
    }
    
    @objc private func signOut() {
        delegate?.signoutRequest()
    }
    
    @objc private func deleteAccount() {
        delegate?.deleteAccount()
    }
    
    @objc private func sendFeedback() {
        delegate?.presentMailComposer()
    }
}
// MARK: - Constraints
extension AccountTabMainView {
    private func setScrollViewConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setStackViewConstraints() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
