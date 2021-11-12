//
//  BookCoverViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/11/2021.
//

import UIKit

class BookCoverViewController: UIViewController {

    // MARK: - Properties
    let imageView = UIImageView()
       
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
    }
}
