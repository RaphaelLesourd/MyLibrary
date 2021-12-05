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
    typealias Snapshot   = NSDiffableDataSourceSnapshot<CommentsSection, AnyHashable>
    typealias DataSource = UITableViewDiffableDataSource<CommentsSection, AnyHashable>
    private var dataSource: DataSource!
    
    private let mainView        = CommentControllerView()
    private let keyboardManager = KeyboardManager()
    private let commentService  : CommentServiceProtocol
    private let validator       : ValidatorProtocol
    private let messageService  : MessageServiceProtocol
    
    private var commentList     : [CommentModel] = []
    private var editedCommentID : String?
    private var book            : Item?
    
    // MARK: - Initializer
    init(book: Item?,
         commentService: CommentServiceProtocol,
         messageService: MessageServiceProtocol,
         validator: ValidatorProtocol) {
        self.commentService = commentService
        self.book           = book
        self.validator      = validator
        self.messageService = messageService
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
        createDataSource()
        configureKeyboard()
        setDelegates()
        setTargets()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        getComments()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        commentService.commentListener?.remove()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
  
    private func setTargets() {
        mainView.refresherControl.addTarget(self, action: #selector(getComments), for: .valueChanged)
    }
    
    private func setDelegates() {
        mainView.inputBar.delegate  = self
        mainView.tableView.delegate = self
    }
    
    private func configureKeyboard() {
        IQKeyboardManager.shared.enable = false
        keyboardManager.bind(inputAccessoryView: mainView.inputBar)
        keyboardManager.bind(to: mainView.tableView)
    }
    
    // MARK: - Api call
    @objc private func getComments() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        showIndicator(mainView.activityIndicator)
        
        commentService.getComments(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            
            self.mainView.refresherControl.endRefreshing()
            self.hideIndicator(self.mainView.activityIndicator)
            switch result {
            case .success(let comments):
                self.commentList = comments
                self.applySnapshot()
                self.mainView.emptyStateView.isHidden = !comments.isEmpty
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
 
    private func getCommentOwnerDetails(for comment: CommentModel, completion: @escaping (UserModel) -> Void) {
        guard let userID = comment.userID else { return }
        
        self.commentService.getUserDetail(for: userID) { result in
            if case .success(let user) = result {
                guard let user = user else { return }
                completion(user)
            }
        }
    }
    
    private func addComment(with comment: String, commentID: String?) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        showIndicator(mainView.activityIndicator)
        notifyUser(of: comment)
        commentService.addComment(for: bookID, ownerID: ownerID, commentID: commentID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            
            self.hideIndicator(self.mainView.activityIndicator)
            self.editedCommentID = nil
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
                return
            }
        }
        
    }
    
    private func notifyUser(of comment: String) {
        guard let book = book else { return }
        messageService.sendCommentNotification(for: book, message: comment, for: self.commentList) { [weak self] error in
            if let error = error {
                self?.presentAlertBanner(as: .error, subtitle: error.description)
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
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
}
// MARK: - TableView Delegate
extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = dataSource.snapshot().sectionIdentifiers[section]
        let numberOfItemsInsection = dataSource.snapshot().numberOfItems(inSection: section)
        
        let sectionTitleLabel = TextLabel(color: .secondaryLabel, maxLines: 1, alignment: .center, fontSize: 14, weight: .light)
        sectionTitleLabel.text = section.headerTitle.uppercased()
        
        return numberOfItemsInsection == 0 ? nil : sectionTitleLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 21
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = self.contextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        
        guard let comment = dataSource.itemIdentifier(for: indexPath) as? CommentModel else {
            return nil
        }
        let commentOwnerID = comment.userID
        let currentUserID = Auth.auth().currentUser?.uid
        return commentOwnerID == currentUserID ? UISwipeActionsConfiguration(actions: [deleteAction, editAction]) : nil
    }
    
    private func contextMenuAction(for actionType: CategoryManagementAction,
                                   forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
      
        guard let comment = dataSource.itemIdentifier(for: indexPath) as? CommentModel else {
            return UIContextualAction()
        }
        let action = UIContextualAction(style: .destructive, title: actionType.rawValue) { [weak self] (_, _, completion) in
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
    
    private func editComment(for comment: CommentModel) {
        editedCommentID = comment.uid
        mainView.inputBar.inputTextView.text = comment.comment
        mainView.inputBar.inputTextView.becomeFirstResponder()
    }
}

// MARK: - TableView Datasource
extension CommentsViewController {
    
    private func createDataSource() {
        dataSource = DataSource(tableView: mainView.tableView,
                                cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
          
           let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section]
           switch section {
            case .book:
                if let item = item as? Item {
                    let reuseIdentifier = CommentsBookCell.reuseIdentifier
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentsBookCell else {
                        return UITableViewCell() }
                    cell.configure(with: item)
                    return cell
                }
            case .today, .past:
                if let item = item as? CommentModel {
                    let reuseIdentifier = CommentTableViewCell.reuseIdentifier
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.configure(with: item)
                    self?.getCommentOwnerDetails(for: item) { user in
                        cell.configureUser(with: user)
                    }
                    return cell
                }
            case .none:
                return nil
            }
            return nil
        })
        mainView.tableView.dataSource = dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(CommentsSection.allCases)
        snapshot.appendItems([book], toSection: .book)
        
        let todayComments = commentList.filter({ validator.isTimestampToday(for: $0.timestamp) })
        snapshot.appendItems(todayComments, toSection: .today)
        
        let pastComments = commentList.filter({ !validator.isTimestampToday(for: $0.timestamp) })
        snapshot.appendItems(pastComments, toSection: .past)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - InputBar delegate
extension CommentsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        addComment(with: text, commentID: editedCommentID)
        self.mainView.inputBar.inputTextView.text = ""
        self.mainView.inputBar.inputTextView.resignFirstResponder()
    }
}
