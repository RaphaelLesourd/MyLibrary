//
//  ImageStorageProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//
import Foundation

protocol ImageStorageProtocol {
    func storeBookCoverImage(for imageData: Data?, nameID: String, completion: @escaping (Result<String, FirebaseError>) -> Void)
    func updateUserImage(for imageData: Data?, completion: @escaping (FirebaseError?) -> Void)
    func deleteImageFromStorage(for id: String, completion: @escaping (FirebaseError?) -> Void)
}
