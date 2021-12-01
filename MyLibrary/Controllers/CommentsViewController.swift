//
//  CommentsViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import Foundation
import UIKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import FirebaseAuth

class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<CommentsSection, AnyHashable>
    typealias DataSource = UITableViewDiffableDataSource<CommentsSection, AnyHashable>
    private var dataSource: DataSource!
    
    private let tableView         = UITableView(frame: .zero, style: .insetGrouped)
    private let activityIndicator = UIActivityIndicatorView()
    private let refresherControl  = UIRefreshControl()
    private let keyboardManager   = KeyboardManager()
    private let inputBar          = InputBarAccessoryView()
    private let commentService    : CommentServiceProtocol
    private let validator         : ValidatorProtocol
    
    private var commentList     : [CommentModel] = []
    private var editedCommentID : String?
    private var book            : Item
    
    // MARK: - Initializer
    init(book: Item, commentService: CommentServiceProtocol, validator: ValidatorProtocol) {
        self.commentService = commentService
        self.book           = book
        self.validator      = validator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Text.ControllerTitle.comments
        view.backgroundColor = .viewControllerBackgroundColor
        makeDataSource()
        configureTableView()
        configureKeyboard()
        configureInputBar()
        configureRefresherControl()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        getComments()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        commentService.commentListener?.remove()
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - Setup
    private func addNavigationBarButtons() {
        let activityIndicactorButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier)
        tableView.register(CommentsBookCell.self, forCellReuseIdentifier: CommentsBookCell.reuseIdentifier)
        tableView.backgroundColor              = .clear
        tableView.frame                        = view.bounds
        tableView.contentInset                 = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
        tableView.rowHeight                    = UITableView.automaticDimension
        tableView.estimatedRowHeight           = 200
        tableView.alwaysBounceVertical         = true
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection              = false
        tableView.delegate                     = self
    }
    
    private func configureRefresherControl() {
        tableView.refreshControl = refresherControl
        refresherControl.addTarget(self, action: #selector(getComments), for: .valueChanged)
    }
    
    private func configureInputBar() {
        inputBar.delegate = self
        inputBar.inputTextView.isImagePasteEnabled = false
        inputBar.backgroundView.backgroundColor = .secondarySystemBackground
        let inputTextView = inputBar.inputTextView
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.backgroundColor = .tertiarySystemBackground
        inputTextView.font = UIFont.systemFont(ofSize: 18.0)
        inputTextView.placeholderLabel.text = "Ce que vous en pensez..."
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
        
        let sendButton = inputBar.sendButton
        sendButton.image = UIImage(systemName: "paperplane.fill")
        sendButton.tintColor = .label
        sendButton.title = nil
        sendButton.setSize(CGSize(width: 30, height: 30), animated: true)
    }
    
    private func configureKeyboard() {
        IQKeyboardManager.shared.enable = false
        view.addSubview(inputBar)
        keyboardManager.bind(inputAccessoryView: inputBar)
        keyboardManager.bind(to: tableView)
    }
    
    // MARK: - Api call
    @objc private func getComments() {
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        showIndicator(activityIndicator)
        
        commentService.getComments(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            
            self.refresherControl.endRefreshing()
            self.hideIndicator(self.activityIndicator)
            switch result {
            case .success(let comments):
                DispatchQueue.main.async {
                    self.commentList = comments
                    self.applySnapshot()
                    self.handleEmptytResultFromApi()
                }
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func handleEmptytResultFromApi() {
        if commentList.isEmpty {
            presentAlert(withTitle: Text.Alert.noCommentsTitle, message: Text.Alert.noCommentsMessage, withCancel: true) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            } actionHandler: { [weak self] _ in
                self?.inputBar.inputTextView.becomeFirstResponder()
            }
        }
    }
    
    private func getCommentOwnerDetails(for comment: CommentModel, completion: @escaping (CurrentUser) -> Void) {
        guard let userID = comment.userID else { return }
        
        self.commentService.getUserDetail(for: userID) { result in
            if case .success(let user) = result {
                guard let user = user else { return }
                completion(user)
            }
        }
    }
    
    private func addComment(with comment: String, commentID: String?) {
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        
        showIndicator(activityIndicator)
        commentService.addComment(for: bookID, ownerID: ownerID, commentID: commentID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            
            self.hideIndicator(self.activityIndicator)
            self.editedCommentID = nil
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func deleteComment(for comment: CommentModel) {
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        
        showIndicator(activityIndicator)
        commentService.deleteComment(for: bookID, ownerID: ownerID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            
            self.hideIndicator(self.activityIndicator)
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
        action.image           = actionType.icon
        action.backgroundColor = actionType.color
        return action
    }
    
    private func editComment(for comment: CommentModel) {
        editedCommentID = comment.uid
        inputBar.inputTextView.text = comment.comment
        inputBar.inputTextView.becomeFirstResponder()
    }
}

// MARK: - TableView Datasource
extension CommentsViewController {
    
    private func makeDataSource() {
       dataSource = DataSource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
          
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
        tableView.dataSource = dataSource
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
        self.inputBar.inputTextView.text = ""
        self.inputBar.inputTextView.resignFirstResponder()
    }
}
