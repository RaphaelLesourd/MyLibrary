//
//  UserCellAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import FirebaseAuth

protocol UserCellMapper {
    func makeUserCellUI(with user: UserModelDTO) -> UserCellUI
}

extension UserCellMapper {
    func makeUserCellUI(with user: UserModelDTO) -> UserCellUI {
        let currentUser: Bool = user.userID == Auth.auth().currentUser?.uid
        return UserCellUI(userName: user.displayName.capitalized,
                          currentUser: currentUser,
                          profileImage: user.photoURL)
        
    }
}
