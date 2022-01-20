//
//  CommentServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol CommentServiceProtocol {
    func addComment(for bookID: String, ownerID: String, commentID: String?, comment: String,
                    completion: @escaping (FirebaseError?) -> Void)
    func getComments(for bookID: String, ownerID: String, completion: @escaping (Result<[CommentModel], FirebaseError>) -> Void)
    func deleteComment(for bookID: String, ownerID: String, comment: CommentModel, completion: @escaping (FirebaseError?) -> Void)
    func getUserDetail(for userID: String, completion: @escaping (Result<UserModel?, FirebaseError>) -> Void)
    func removeListener()
}
