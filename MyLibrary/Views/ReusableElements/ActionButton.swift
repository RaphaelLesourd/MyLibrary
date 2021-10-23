//
//  ActionButton.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation
import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, backgroundColor: UIColor = .systemOrange) {
        self.init(frame:  .zero)
        configureButton(with: title, backgroundColor: backgroundColor)
    }
    
    private func configureButton(with title: String = "", backgroundColor: UIColor = .appTintColor) {
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.cornerStyle = .medium
            configuration.baseForegroundColor = .white
            configuration.baseBackgroundColor = backgroundColor
            configuration.buttonSize = .large
            configuration.titlePadding = 10
            var container = AttributeContainer()
            container.font = font
            configuration.attributedTitle = AttributedString(title, attributes: container)
            self.configuration = configuration
        } else {
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = font
            self.rounded(radius: 10, backgroundcolor: backgroundColor)
        }
    }
}
