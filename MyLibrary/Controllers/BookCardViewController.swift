//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class BookCardViewController: UIViewController {

    // MARK: - Properties
    private let mainView = BookCardMainView()
    
    // MARK: - Intializers
    override func loadView() {
        view = mainView
        view.backgroundColor = .secondarySystemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configure()
        addCommentButton()
    }
    
    // MARK: - Setup
    private func addCommentButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "quote.bubble"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addComment))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    // MARK: - Navigation
    @objc private func addComment() {
        
    }
  
}
