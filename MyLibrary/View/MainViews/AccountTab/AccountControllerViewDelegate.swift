//
//  AccountControllerViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 20/01/2022.
//

protocol AccountViewDelegate: AnyObject {
    func signoutRequest()
    func deleteAccount()
}

protocol ProfileViewDelegate: AnyObject {
    func presentImagePicker()
}

protocol ContactViewDelegate: AnyObject {
    func presentMailComposer()
}
