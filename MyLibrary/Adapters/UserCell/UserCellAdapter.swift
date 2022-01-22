//
//  UserCellAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import FirebaseAuth

protocol UserCellAdapter {
    func setUserData(with user: UserModel) -> UserCellRepresentable
}

extension UserCellAdapter {
    func setUserData(with user: UserModel) -> UserCellRepresentable {
        let currentUser: Bool = user.userID == Auth.auth().currentUser?.uid
        return UserCellRepresentable(userName: user.displayName.capitalized,
                                     currentUser: currentUser,
                                     profileImage: user.photoURL)
        
    }
}
