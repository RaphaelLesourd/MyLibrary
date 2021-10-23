//
//  BookCardViewController.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

class BookCardViewController: UIViewController {

    private let mainView = BookCardMainView()
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .secondarySystemBackground
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
}
