//
//  ButtonCell.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/10/2021.
//

import Foundation
import UIKit

class ButtonStaticCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setButtonConstraints()
        setActivityIndicatorCosntraints()
        activityIndicator.hidesWhenStopped = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, systemImage: String = "", tintColor: UIColor, backgroundColor: UIColor) {
        self.init()
        self.actionButton.configureButton(with: title,
                                          systemImage: systemImage,
                                          tintColor: tintColor,
                                          backgroundColor: backgroundColor)
    }
    private let activityIndicator = UIActivityIndicatorView()
    let actionButton = ActionButton()
    
    func displayActivityIndicator(_ state: Bool) {
        state ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        actionButton.alpha = state ? 0.3 : 1
        actionButton.isUserInteractionEnabled = !state
    }
}
extension ButtonStaticCell {
    private func setActivityIndicatorCosntraints() {
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    private func setButtonConstraints() {
        contentView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -3),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
