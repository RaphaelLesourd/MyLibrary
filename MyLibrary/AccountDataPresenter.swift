//
//  AccountDataPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

import UIKit

class AccountDataPresenter {
    
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever) {
        self.imageRetriever = imageRetriever
    }
}
// MARK: - Account presenter protocol
extension AccountDataPresenter: AccountPresenter {
    
    func configure(_ view: AccountControllerView, with user: UserModel) {
        view.profileCell.emailLabel.text = user.email
        view.displayNameCell.textField.clearButtonMode = .always
        view.displayNameCell.textField.text = user.displayName
      
        imageRetriever.getImage(for: user.photoURL) { image in
            view.profileCell.profileImageButton.setImage(image, for: .normal)
        }
    }
}
