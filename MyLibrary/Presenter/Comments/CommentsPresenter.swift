//
//  CommentsPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//

protocol CommentsPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func addCommentToInputBar(for comment: CommentModel)
}

class CommentPresenter {
    
    // MARK: - Properties
    weak var view: CommentsPresenterView?
    var book: Item?
    var editedCommentID: String?
    var commentList: [CommentModel] = []
    var bookCellRepresentable: [CommentBookCellRepresentable] = []
 
    private let commentService: CommentServiceProtocol
    private let messageService: MessageServiceProtocol
    private let formatter: Formatter
    
    // MARK: - Intializer
    init(commentService: CommentServiceProtocol,
         messageService: MessageServiceProtocol,
         formatter: Formatter) {
        self.commentService = commentService
        self.messageService = messageService
        self.formatter = formatter
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
    
    // MARK: - Notification
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
    
    // MARK: - Cell
    func getCommentDetails(for comment: CommentModel,
                           completion: @escaping(CommentCellRepresentable) -> Void) {
        let userID = comment.userID
        view?.showActivityIndicator()
        
        commentService.getUserDetail(for: userID) { [weak self] result in
            self?.view?.stopActivityIndicator()
            if case .success(let user) = result {
                if let data = self?.makeCommentCellRepresentable(with: comment, and: user) {
                    completion(data)
                }
            }
        }
    }
    
    func getBookDetails() {
        guard let book = book,
              let ownerID = book.ownerID else { return }
        var name = String()
        view?.showActivityIndicator()
        
        commentService.getUserDetail(for: ownerID) { [weak self] result in
            self?.view?.stopActivityIndicator()
            
            if case .success(let owner) = result {
                name = owner.displayName
            }
            if let data = self?.makeCommentBookCellRepresentable(with: book, and: name) {
                self?.bookCellRepresentable = [data]
                self?.view?.applySnapshot(animatingDifferences: true)
            }
        }
    }
    
    func presentSwipeAction(for comment: CommentModel, actionType: CellSwipeActionType) {
        switch actionType {
        case .delete:
            deleteComment(for: comment)
        case .edit:
            editedCommentID = comment.uid
            view?.addCommentToInputBar(for: comment)
        }
    }
    
    // MARK: - Private functions
    private func makeCommentBookCellRepresentable(with book: Item, and ownerName: String) -> CommentBookCellRepresentable {
        let title = book.volumeInfo?.title?.capitalized
        let authors = book.volumeInfo?.authors?.joined(separator: ", ")
        let image = book.volumeInfo?.imageLinks?.thumbnail
        return CommentBookCellRepresentable(title: title,
                                            authors: authors,
                                            image: image,
                                            ownerName: ownerName)
    }
    
    private func makeCommentCellRepresentable(with comment: CommentModel, and user: UserModel) -> CommentCellRepresentable {
        let date = formatter.formatTimeStampToRelativeDate(for: comment.timestamp)
        return CommentCellRepresentable(message: comment.message,
                                        date: date,
                                        userName: user.displayName,
                                        profileImage: user.photoURL)
    }
}
