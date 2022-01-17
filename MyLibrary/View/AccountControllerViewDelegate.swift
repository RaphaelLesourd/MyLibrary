//
//  AccountControllerViewDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
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
