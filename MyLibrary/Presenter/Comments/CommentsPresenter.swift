//
//  CommentsPresenter.swift
//  MyLibrary
//
//  Created by Birkyboy on 19/01/2022.
//
import FirebaseAuth

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
    
    /// Convert Item object to object to be used by the view to display data it needs
    /// - Parameters:
    ///   - book: Item object
    ///   - ownerName: String representing the name of the book owner
    private func makeCommentBookCellRepresentable(with book: Item,
                                                  and ownerName: String) -> CommentBookCellRepresentable {
        let title = book.volumeInfo?.title?.capitalized
        let authors = book.volumeInfo?.authors?.joined(separator: ", ")
        let image = book.volumeInfo?.imageLinks?.thumbnail
        return CommentBookCellRepresentable(title: title,
                                            authors: authors,
                                            image: image,
                                            ownerName: ownerName)
    }
}

extension CommentPresenter: CommentPresenting {
   
    // MARK: API call
    /// Fetch all the comments for the current book
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
    
    /// Add comment to the database.
    /// - Parameters:
    ///  - newComment: String of the comment message to add
    ///  - commentID: Optional String of the comment.
    /// The optional allows to either use the ID to update the current comment or if nil a new ID is created for a new comment
    func addComment(with newComment: String, commentID: String?) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        view?.showActivityIndicator()
        
        commentService.addComment(for: bookID,
                                     ownerID: ownerID,
                                     commentID: commentID,
                                     comment: newComment) { [weak self] error in
            self?.view?.stopActivityIndicator()
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
            self?.editedCommentID = nil
            self?.notifyUser(of: newComment, book: self?.book)
        }
    }
    
    /// Delete comment from the database
    /// - Parameters:
    /// - comment: CommentModel object of the comment to delete.
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
    
    // MARK: Notification
    
    /// Notify the user of a new comment
    /// - Parameters:
    ///  - newComment: String of the comment message to send.
    ///  - book: Optional Item object of the book the comment belongs to.
    func notifyUser(of newComment: String, book: Item?) {
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
    
    /// Convert a CommentModel object tp CommentCellRepresentable used to by the cell to display data.
    /// - Parameters:
    /// - comment: CommentModel object of the comment to convert
    func makeCommentCellRepresentable(with comment: CommentModel) -> CommentCellRepresentable {
        let isCurrentUser = comment.userID == Auth.auth().currentUser?.uid
        let date = formatter.formatTimeStampToRelativeDate(for: comment.timestamp)
        return CommentCellRepresentable(message: comment.message,
                                        date: date,
                                        userName: comment.userName.capitalized,
                                        profileImage: comment.userPhotoURL,
                                        currentUser: isCurrentUser)
    }
    
    /// Get book details including user name from the data base and convert book Item object and
    /// user UserModel object to CommentBookCellRepresentable used by the cell to display data.
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
    
    /// Handle the cell trailing swipe actions and call the methods for the action
    /// - Parameters:
    ///   - actionType: CellSwipeActionType Enum case
    ///   - comment: CommentModel object of the current comment
    func presentSwipeAction(for comment: CommentModel, actionType: CellSwipeActionType) {
        switch actionType {
        case .delete:
            deleteComment(for: comment)
        case .edit:
            editedCommentID = comment.uid
            view?.addCommentToInputBar(for: comment)
        }
    }
}
