//
//  UserCellDataPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

import UIKit
import FirebaseAuth

class UserCellConfiguration {
    private var imageRetriever: ImageRetriever
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever) {
        self.imageRetriever = imageRetriever
    }
}
extension UserCellConfiguration: UserCellConfigure {
    
    func setData(with user: UserModel, completion: @escaping (UserCellData) -> Void) {
        let userName = user.displayName.capitalized
        let currentUser: Bool = user.userID == Auth.auth().currentUser?.uid
        
        imageRetriever.getImage(for: user.photoURL) { image in
            let followedUserData = UserCellData(image: image,
                                                userName: userName,
                                                currentUser: currentUser)
            completion(followedUserData)
        }
    }
}
