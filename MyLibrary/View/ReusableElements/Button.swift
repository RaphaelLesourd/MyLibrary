//
//  ActionButton.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class Button: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = true
        buttonHeightAnchor = self.heightAnchor.constraint(equalToConstant: 50)
        setConstraints()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String,
                     icon: UIImage = UIImage(),
                     imagePlacement: NSDirectionalRectEdge = .leading,
                     tintColor: UIColor = .appTintColor,
                     backgroundColor: UIColor = .appTintColor) {
        self.init(frame:  .zero)
        configureButton(with: title,
                        systemImage: icon,
                        imagePlacement: imagePlacement,
                        tintColor: tintColor,
                        backgroundColor: backgroundColor)
    }
    
    var buttonHeightAnchor = NSLayoutConstraint()
    private let activityIndicator = UIActivityIndicatorView()
    
    func configureButton(with title: String = "",
                         systemImage: UIImage? = nil,
                         imagePlacement: NSDirectionalRectEdge = .leading,
                         tintColor: UIColor = .appTintColor,
                         backgroundColor: UIColor = .appTintColor) {
       
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.tinted()
            configuration?.cornerStyle = .medium
            configuration?.baseForegroundColor = tintColor
            configuration?.baseBackgroundColor = backgroundColor
            configuration?.buttonSize = .large
            configuration?.titlePadding = 10
            configuration?.image = systemImage
            configuration?.imagePadding = 10
            configuration?.imagePlacement = imagePlacement
            var container = AttributeContainer()
            container.font = .button
            configuration?.attributedTitle = AttributedString(title, attributes: container)
        } else {
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = .button
            self.titleLabel?.adjustsFontSizeToFitWidth = true
            self.roundView(radius: 10, backgroundColor: backgroundColor.withAlphaComponent(0.2))
            self.setTitleColor(tintColor, for: .normal)
            self.titleEdgeInsets = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        }
    }
    
    func toggleActivityIndicator(to on: Bool) {
        if #available(iOS 15.0, *) {
            self.configuration?.showsActivityIndicator = on
        } else {
            on ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        }
        self.alpha = on ? 0.3 : 1
        self.isUserInteractionEnabled = !on
    }
}

extension Button {
    private func setConstraints() {
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonHeightAnchor
        ])
    }
}
