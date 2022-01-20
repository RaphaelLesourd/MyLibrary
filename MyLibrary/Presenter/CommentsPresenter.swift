//
//  CommentsPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

protocol CommentsPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
}

class CommentPresenter {
    
    // MARK: - Properties
    weak var view: CommentsPresenterView?
    var book: Item?
    var editedCommentID: String?
    var commentList: [CommentModel] = []
    
    private let commentService: CommentServiceProtocol
    private let messageService: MessageServiceProtocol
    
    // MARK: - Intializer
    init(commentService: CommentServiceProtocol,
         messageService: MessageServiceProtocol) {
        self.commentService = commentService
        self.messageService = messageService
    }
    
    // MARK: - API Call
    func getComments() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        commentService.getComments(for: bookID, ownerID: ownerID) { [weak self] result in
            self?.view?.stopActivityIndicator()
            switch result {
            case .success(let comments):
                self?.commentList = comments
                self?.view?.applySnapshot(animatingDifferences: true)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    func addComment(with newComment: String,
                    commentID: String?) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        commentService.addComment(for: bookID,
                                     ownerID: ownerID,
                                     commentID: commentID,
                                     comment: newComment) { [weak self] error in
            self?.view?.stopActivityIndicator()
            self?.editedCommentID = nil
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.notifyUser(of: newComment, book: self?.book)
        }
    }
    
    func deleteComment(for comment: CommentModel) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        
        commentService.deleteComment(for: bookID,
                                        ownerID: ownerID,
                                        comment: comment) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.view?.applySnapshot(animatingDifferences: true)
        }
    }
    
    func notifyUser(of newComment: String,
                    book: Item?) {
        guard let book = book else { return }
        view?.showActivityIndicator()
        messageService.sendCommentPushNotification(for: book,
                                                      message: newComment,
                                                      for: self.commentList) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
        }
    }
}
