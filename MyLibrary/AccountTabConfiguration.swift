//
//  AccountTabConfiguration.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

import UIKit

class AccountTabConfiguration {
    
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever) {
        self.imageRetriever = imageRetriever
    }
}
// MARK: - Account presenter protocol
extension AccountTabConfiguration: AccountTabConfigure {
    
    func configure(_ view: AccountTabMainView, with user: UserModel) {
        view.accountView.emailLabel.text = user.email
        view.accountView.userNameTextfield.text = user.displayName
      
        imageRetriever.getImage(for: user.photoURL) { image in
            view.accountView.profileImageButton.setImage(image, for: .normal)
        }
    }
}
