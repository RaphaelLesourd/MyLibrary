//
//  CommentServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class CommentServiceMock: CommentServiceProtocol {
    
    private var successTest: Bool
    
    init(successTest: Bool) {
        self.successTest = successTest
    }
    
    func addComment(for bookID: String,
                    ownerID: String,
                    commentID: String?,
                    comment: String,
                    completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func getComments(for bookID: String, ownerID: String, completion: @escaping (Result<[CommentDTO], FirebaseError>) -> Void) {
        successTest ? completion(.success([])) : completion(.failure(.firebaseError(PresenterError.fail)))
    }
    
    func deleteComment(for bookID: String, ownerID: String, comment: CommentDTO, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func getUserDetail(for userID: String, completion: @escaping (Result<UserModelDTO, FirebaseError>) -> Void) {
        if successTest {
            completion(.success(PresenterFakeData.user))
        } else {
            completion(.failure(.firebaseError(PresenterError.fail)))
        }
    }
    
    func removeListener() {}
    
    
}
