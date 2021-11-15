//
//  BookCoverViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/11/2021.
//

import UIKit

class BookCoverViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    private var scrollView = ImageScrollView()
    var image = UIImage()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        setupScrollViewConstraints()
        scrollView.imageView.image = image
        scrollView.setZoomScale(2, animated: false)
        scrollView.scrollViewDidZoom(self.scrollView)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeNavigationBarClear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreNavigationDefaultBar()
    }
}
// MARK: - Constraints
extension BookCoverViewController {
    private func setupScrollViewConstraints() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
