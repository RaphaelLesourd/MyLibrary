//
//  ImageStorageServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class ImageServiceMock: ImageStorageProtocol {
    
    private var successTest: Bool
    
    init(successTest: Bool) {
        self.successTest = successTest
    }
    
    func saveImage(for imageData: Data?, nameID: String
                   , completion: @escaping (Result<String, FirebaseError>) -> Void) {
        successTest ? completion(.success("")) : completion(.failure(.firebaseError(PresenterError.fail)))
    }
    
    func updateUserImage(for imageData: Data?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func deleteImageFromStorage(for id: String, completion: @escaping (FirebaseError?) -> Void) {
        completion(nil)
    }
    
    
}
