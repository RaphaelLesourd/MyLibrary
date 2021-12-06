//
//  ActionButton.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureButton()
        setActivityIndicatorCosntraints()
        self.translatesAutoresizingMaskIntoConstraints = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String,
                     systemImage: String = "book.fill",
                     imagePlacement: NSDirectionalRectEdge = .leading,
                     tintColor: UIColor = .appTintColor,
                     backgroundColor: UIColor = .appTintColor) {
        self.init(frame:  .zero)
        configureButton(with: title,
                        systemImage: systemImage,
                        imagePlacement: imagePlacement,
                        tintColor: tintColor,
                        backgroundColor: backgroundColor)
    }
    
    private let activityIndicator = UIActivityIndicatorView()
    
    func configureButton(with title: String = "",
                         systemImage: String = "",
                         imagePlacement: NSDirectionalRectEdge = .leading,
                         tintColor: UIColor = .appTintColor,
                         backgroundColor: UIColor = .appTintColor) {
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.tinted()
            configuration?.image               = UIImage(systemName: systemImage)
            configuration?.cornerStyle         = .medium
            configuration?.baseForegroundColor = tintColor
            configuration?.baseBackgroundColor = backgroundColor
            configuration?.buttonSize          = .large
            configuration?.titlePadding        = 10
            configuration?.image               = UIImage(systemName: systemImage)
            configuration?.imagePadding        = 10
            configuration?.imagePlacement      = imagePlacement
            var container  = AttributeContainer()
            container.font = font
            configuration?.attributedTitle = AttributedString(title, attributes: container)
        } else {
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = font
            self.rounded(radius: 10, backgroundColor: tintColor.withAlphaComponent(0.2))
            self.setTitleColor(tintColor, for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        }
    }
    
    func displayActivityIndicator(_ state: Bool) {
        state ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        self.alpha = state ? 0.3 : 1
        self.isUserInteractionEnabled = !state
    }
}

extension ActionButton {
    private func setActivityIndicatorCosntraints() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
