//
//  CommentsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import UIKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import FirebaseAuth

class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot = NSDiffableDataSourceSnapshot<CommentsSection, AnyHashable>
    typealias DataSource = UITableViewDiffableDataSource<CommentsSection, AnyHashable>
    
    private let mainView = CommentControllerView()
    private let keyboardManager = KeyboardManager()
    private let commentService: CommentServiceProtocol
    private let validator: ValidatorProtocol
    private let messageService: MessageServiceProtocol
    private let cellPresenter: CellPresenter?
    private let commentCellPresenter: CommentCellPresenter?
    
    private lazy var dataSource = makeDataSource()
    private var commentList: [CommentModel] = []
    private var editedCommentID: String?
    private var book: Item?
    
    // MARK: - Initializer
    init(book: Item?,
         commentService: CommentServiceProtocol,
         messageService: MessageServiceProtocol,
         validator: ValidatorProtocol) {
        self.book = book
        self.commentService = commentService
        self.messageService = messageService
        self.validator = validator
        self.cellPresenter = BookCellPresenter(imageRetriever: KFImageRetriever())
        self.commentCellPresenter = CommentCellDataPresenter(imageRetriever: KFImageRetriever(),
                                                             formatter: Formatter())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
        view.backgroundColor = .viewControllerBackgroundColor
        title = Text.ControllerTitle.comments
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enableAutoToolbar = false
        mainView.tableView.dataSource = dataSource
        configureKeyboard()
        setDelegates()
        setTargets()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        getComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        commentService.removeListener()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func setTargets() {
        mainView.refresherControl.addAction(UIAction(handler: { [weak self] _ in
            self?.getComments()
        }), for: .valueChanged)
    }
    
    private func setDelegates() {
        mainView.emptyStateView.delegate = self
        mainView.inputBar.delegate = self
        mainView.tableView.delegate = self
    }
    
    private func configureKeyboard() {
        IQKeyboardManager.shared.enable = false
        keyboardManager.bind(inputAccessoryView: mainView.inputBar)
        keyboardManager.bind(to: mainView.tableView)
    }
    
    // MARK: - Api call
    private func getComments() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        showIndicator(mainView.activityIndicator)
        
        commentService.getComments(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.mainView.refresherControl.endRefreshing()
                self.hideIndicator(self.mainView.activityIndicator)
                switch result {
                case .success(let comments):
                    self.commentList = comments
                    self.applySnapshot()
                case .failure(let error):
                    AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
    }
    
    private func addComment(with newComment: String, commentID: String?) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        showIndicator(mainView.activityIndicator)
        
        notifyUser(of: newComment)
        commentService.addComment(for: bookID, ownerID: ownerID, commentID: commentID, comment: newComment) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            self.editedCommentID = nil
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
        }
    }
    
    private func deleteComment(for comment: CommentModel) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        showIndicator(mainView.activityIndicator)
        
        commentService.deleteComment(for: bookID, ownerID: ownerID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func getCommentOwnerDetails(for comment: CommentModel, completion: @escaping (UserModel?) -> Void) {
        guard let userID = comment.userID else { return }
        
        self.commentService.getUserDetail(for: userID) { [weak self] result in
            switch result {
            case .success(let user):
                guard let user = user else {
                    self?.deleteComment(for: comment)
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(user)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func getBookOwnerDetails(completion: @escaping (UserModel?) -> Void) {
        guard let ownerID = book?.ownerID else { return }
        self.commentService.getUserDetail(for: ownerID) { result in
            if case .success(let owner) = result {
                DispatchQueue.main.async {
                    completion(owner)
                }
            }
        }
    }
    
    private func notifyUser(of newComment: String) {
        guard let book = book else { return }
        messageService.sendCommentNotification(for: book, message: newComment, for: self.commentList) { error in
            if let error = error {
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
        }
    }
}
// MARK: - TableView Delegate
extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        switch section {
        case .book:
            return 140
        case .today, .past:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource.snapshot().sectionIdentifiers[section]
        let numberOfItemsInsection = dataSource.snapshot().numberOfItems(inSection: section)
        
        let sectionTitleLabel = TextLabel(color: .secondaryLabel,
                                          maxLines: 1,
                                          alignment: .center,
                                          fontSize: 14,
                                          weight: .light)
        sectionTitleLabel.text = section.headerTitle.uppercased()
        
        return numberOfItemsInsection == 0 ? nil : sectionTitleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21
    }
    
    /// Adds swipe gestures to edit or delete comment
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = self.contextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        
        guard let comment = dataSource.itemIdentifier(for: indexPath) as? CommentModel else { return nil }
        let commentOwnerID = comment.userID
        let currentUserID = Auth.auth().currentUser?.uid
        return commentOwnerID == currentUserID ? UISwipeActionsConfiguration(actions: [deleteAction, editAction]) : nil
    }
    
    /// Handles swipe gesture actions
    private func contextMenuAction(for actionType: ActionType, forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        guard let comment = dataSource.itemIdentifier(for: indexPath) as? CommentModel else {
            return UIContextualAction()
        }
        let action = UIContextualAction(style: .destructive, title: actionType.title) { [weak self] (_, _, completion) in
            guard let self = self else {return}
            switch actionType {
            case .delete:
                self.deleteComment(for: comment)
            case .edit:
                self.editComment(for: comment)
            }
            completion(true)
        }
        action.backgroundColor = actionType.color
        action.image = actionType.icon
        return action
    }
    
    /// Add comment text to the input bar to edit and save the comment.
    private func editComment(for comment: CommentModel) {
        editedCommentID = comment.uid
        mainView.inputBar.inputTextView.text = comment.comment
        mainView.inputBar.inputTextView.becomeFirstResponder()
    }
}

// MARK: - TableView Datasource
extension CommentsViewController {
    
    /// Create a data source with 3 sections
    ///  - Note: Section 1: The current book, Section 2: Today's comment, Section 3: Past comments.
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: mainView.tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            
            let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .book:
                if let item = item as? Item {
                    let reuseIdentifier = CommentsBookCell.reuseIdentifier
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                   for: indexPath) as? CommentsBookCell else {
                        return UITableViewCell() }
                    self?.cellPresenter?.setBookData(for: item) { bookData in
                        cell.configure(with: bookData)
                    }
                    self?.getBookOwnerDetails(completion: { owner in
                        cell.configureOwnerDetails(with: owner)
                    })
                    return cell
                }
            case .today, .past:
                if let item = item as? CommentModel {
                    let reuseIdentifier = CommentTableViewCell.reuseIdentifier
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                   for: indexPath) as? CommentTableViewCell else {
                        return UITableViewCell()
                    }
                    self?.commentCellPresenter?.configure(cell, with: item)
                    self?.setUserDetails(with: item, for: cell)
                    return cell
                }
            case .none:
                return nil
            }
            return nil
        })
        return dataSource
    }
    
    private func setUserDetails(with item: CommentModel, for cell: CommentTableViewCell) {
        getCommentOwnerDetails(for: item) { [weak self] user in
            guard let user = user else { return }
            self?.commentCellPresenter?.setUserDetails(for: cell, with: user)
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.book])
        snapshot.appendItems([book], toSection: .book)
        mainView.emptyStateView.isHidden = !commentList.isEmpty
        
        let todayComments = commentList.filter({ validator.isTimestampToday(for: $0.timestamp) })
        if !todayComments.isEmpty {
            snapshot.appendSections([.today])
            snapshot.appendItems(todayComments, toSection: .today)
        }
        
        let pastComments = commentList.filter({ !validator.isTimestampToday(for: $0.timestamp) })
        if !pastComments.isEmpty {
            snapshot.appendSections([.past])
            snapshot.appendItems(pastComments, toSection: .past)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - InputBar delegate
extension CommentsViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        addComment(with: text, commentID: editedCommentID)
        mainView.inputBar.inputTextView.text = ""
        mainView.inputBar.inputTextView.resignFirstResponder()
    }
}
// MARK: - EmptystateViewDelegate
extension CommentsViewController: EmptyStateViewDelegate {
    func didTapButton() {
       mainView.inputBar.inputTextView.becomeFirstResponder()
    }
}
