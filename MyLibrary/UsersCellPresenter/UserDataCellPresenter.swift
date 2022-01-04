//
//  UserCellDataPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/01/2022.
//

import UIKit

class FollowedUserDataCellPresenter {
    private var imageRetriever: ImageRetriever
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever) {
        self.imageRetriever = imageRetriever
    }
}
extension FollowedUserDataCellPresenter: UserCellPresenter {
    
    func setData(with user: UserModel, completion: @escaping (UserCellData) -> Void) {
        let userName = user.displayName.capitalized
     
        imageRetriever.getImage(for: user.photoURL) { image in
            let followedUserData = UserCellData(image: image, userName: userName)
            completion(followedUserData)
        }
    }
}
