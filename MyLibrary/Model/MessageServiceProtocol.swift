//
//  MessageServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol MessageServiceProtocol {
    func sendCommentPushNotification(for book: Item,
                                     message: String,
                                     for comments: [CommentModel],
                                     completion: @escaping (FirebaseError?) -> Void)
}
