//
//  LoadingFooterSupplementaryView.swift
//  MyLibrary
//
//  Created by Birkyboy on 31/10/2021.
//

import UIKit

class LoadingFooterSupplementaryView: UICollectionReusableView {

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackviewConstrainsts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Subviews
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    func displayActivityIndicator(_ isDisplaying: Bool) {
        activityIndicator.hidesWhenStopped = true
        DispatchQueue.main.async {
            isDisplaying ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
}
// MARK: - Constraints
extension LoadingFooterSupplementaryView {
    private func setStackviewConstrainsts() {
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
