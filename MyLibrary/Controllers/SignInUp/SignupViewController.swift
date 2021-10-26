//
//  SignupViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import UIKit
import PanModal

class SignupViewController: PanModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.configureUI(for: .signup)
    }
}
