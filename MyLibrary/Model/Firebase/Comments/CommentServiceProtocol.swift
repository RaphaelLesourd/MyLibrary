//
//  CommentServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

protocol CommentServiceProtocol {
    func addComment(for bookID: String, ownerID: String, commentID: String?, comment: String,
                    completion: @escaping (FirebaseError?) -> Void)
    func getComments(for bookID: String, ownerID: String, completion: @escaping (Result<[CommentDTO], FirebaseError>) -> Void)
    func deleteComment(for bookID: String, ownerID: String, comment: CommentDTO, completion: @escaping (FirebaseError?) -> Void)
    func removeListener()
}
