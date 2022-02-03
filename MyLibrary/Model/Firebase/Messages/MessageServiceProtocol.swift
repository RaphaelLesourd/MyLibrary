//
//  MessageServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol MessageServiceProtocol {
    func sendCommentPushNotification(for book: ItemDTO,
                                     message: String,
                                     for comments: [CommentDTO],
                                     completion: @escaping (FirebaseError?) -> Void)
}
