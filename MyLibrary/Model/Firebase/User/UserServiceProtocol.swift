//
//  UserServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol UserServiceProtocol {
    func createUserInDatabase(for user: UserModelDTO?, completion: @escaping (FirebaseError?) -> Void)
    func retrieveUser(for userID: String?, completion: @escaping (Result<UserModelDTO?, FirebaseError>) -> Void)
    func updateUserName(with username: String?, completion: @escaping (FirebaseError?) -> Void)
    func deleteUser(completion: @escaping (FirebaseError?) -> Void)
    func updateFcmToken(with token: String)
}
