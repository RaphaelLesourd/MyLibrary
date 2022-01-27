//
//  AccountTabPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//
import Foundation

protocol AccountTabPresenting {
    var view: AccountTabPresenterView? { get set }
    func getProfileData()
    func saveUserName(with userName: String?)
    func saveProfileImage(_ profileImageData: Data?)
    func signoutAccount()
}
