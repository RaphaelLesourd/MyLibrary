//
//  AccountService.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol AccountServiceProtocol {
    func createAccount(for userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void)
    func deleteAccount(with userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void)
    func login(with userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void)
    func signOut(completion: @escaping (FirebaseError?) -> Void)
    func sendPasswordReset(for email: String, completion: @escaping (FirebaseError?) -> Void)
}
