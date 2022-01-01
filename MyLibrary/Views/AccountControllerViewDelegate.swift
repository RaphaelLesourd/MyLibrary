//
//  AccountControllerViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol AccountViewDelegate: AnyObject {
    func presentImagePicker()
    func signoutRequest()
    func deleteAccount()
    func presentMailComposer()
    func presentNewBookViewController()
}
