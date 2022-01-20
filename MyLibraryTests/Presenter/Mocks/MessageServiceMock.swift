//
//  MessageServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class MessageServiceMock: MessageServiceProtocol {
    
    private var successTest: Bool
    
    init(successTest: Bool) {
        self.successTest = successTest
    }
    
    func sendCommentPushNotification(for book: Item,
                                     message: String,
                                     for comments: [CommentModel],
                                     completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
}
