//
//  IpadSideBarView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/12/2021.
//

import UIKit

class AccountTabMainView: UIView {
   
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollViewConstraints()
        setStackViewConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    let profileView = ProfileView()
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
    private func setupView() {
        let device = UIDevice.current.userInterfaceIdiom
        newBookView.isHidden = device != .pad
        stackView.addArrangedSubview(profileView)
        stackView.addArrangedSubview(contactView)
        stackView.addArrangedSubview(newBookView)
        stackView.setCustomSpacing(40, after: contactView)
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
