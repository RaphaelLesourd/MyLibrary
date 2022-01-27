//
//  CommentPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol CommentPresenting {
    var view: CommentsPresenterView? { get set }
    var book: Item? { get set }
    var commentList: [CommentModel] { get set }
    var bookCellRepresentable: [CommentBookCellRepresentable] { get set }
    var editedCommentID: String? { get set }
    func getComments()
    func getBookDetails()
    func addComment(with newComment: String, commentID: String?)
    func deleteComment(for comment: CommentModel)
    func notifyUser(of newComment: String, book: Item?)
    func makeCommentCellRepresentable(with comment: CommentModel) -> CommentCellRepresentable
    func presentSwipeAction(for comment: CommentModel, actionType: CellSwipeActionType)
}
