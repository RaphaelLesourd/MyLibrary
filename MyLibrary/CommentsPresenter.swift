//
//  CommentsPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

import Foundation

protocol CommentsPresenterView: AnyObject {
    func updateCommentList(with comments: [CommentModel])
    func applySnapshot(animatingDifferences: Bool)
    func showActivityIndicator()
    func stopActivityIndicator()
}

class CommentPresenter {
    
    // MARK: - Properties
    weak var view: CommentsPresenterView?
    var book: Item?
    var editedCommentID: String?
    
    private let commentService: CommentServiceProtocol
    private let messageService: MessageServiceProtocol
    private var commentList: [CommentModel] = []
    
    // MARK: - Intializer
    init(commentService: CommentServiceProtocol,
         messageService: MessageServiceProtocol) {
        self.commentService = commentService
        self.messageService = messageService
    }
    
    // MARK: - API Calls
    func getComments() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        commentService.getComments(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.stopActivityIndicator()
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self.commentList = comments
                    self.view?.updateCommentList(with: comments)
                }
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
       
        notifyUser(of: newComment, book: book)
       
        commentService.addComment(for: bookID,
                                     ownerID: ownerID,
                                     commentID: commentID,
                                     comment: newComment) { [weak self] error in
            guard let self = self else { return }
            self.view?.stopActivityIndicator()
            self.editedCommentID = nil
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
        }
    }
    
    func deleteComment(for comment: CommentModel) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        self.view?.showActivityIndicator()
        
        commentService.deleteComment(for: bookID,
                                        ownerID: ownerID,
                                        comment: comment) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
            DispatchQueue.main.async {
                self?.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    func notifyUser(of newComment: String,
                    book: Item?) {
        guard let book = book else { return }
        messageService.sendCommentPushNotification(for: book,
                                                      message: newComment,
                                                      for: self.commentList) { error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
        }
    }
}
