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
    typealias Snapshot   = NSDiffableDataSourceSnapshot<SingleSection, CommentModel>
    typealias DataSource = UITableViewDiffableDataSource<SingleSection, CommentModel>
    private lazy var dataSource = makeDataSource()
    
    private let tableView         = UITableView(frame: .zero, style: .insetGrouped)
    private let activityIndicator = UIActivityIndicatorView()
    private let refresherControl  = UIRefreshControl()
    
    private let commentService  : CommentServiceProtocol
    private var keyboardManager = KeyboardManager()
    private var footerView      = LoadingFooterSupplementaryView()
    private var inputBar        = InputBarAccessoryView()
    private var commentList     : [CommentModel] = []
    private var editedCommentID : String?
    
    var book: Item?
    
    // MARK: - Initializer
    init(commentService: CommentServiceProtocol) {
        self.commentService = commentService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Commentaires"
        view.backgroundColor = .viewControllerBackgroundColor
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
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor              = .clear
        tableView.frame                        = view.bounds
        tableView.contentInset                 = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
        tableView.rowHeight                    = UITableView.automaticDimension
        tableView.estimatedRowHeight           = 300
        tableView.alwaysBounceVertical         = true
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection              = false
        tableView.delegate                     = self
        tableView.dataSource                   = dataSource
    }
    
    private func configureRefresherControl() {
        tableView.refreshControl = refresherControl
        refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
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
        inputTextView.placeholderLabel.text = "Commentaire"
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
    private func getComments() {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        
        showIndicator(activityIndicator)
        commentService.getComments(for: bookID, ownerID: ownerID) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refresherControl.endRefreshing()
                self.hideIndicator(self.activityIndicator)
                switch result {
                case .success(let comments):
                    self.commentList = comments
                    self.applySnapshot()
                case .failure(let error):
                    self.presentAlertBanner(as: .error, subtitle: error.description)
                }
            }
        }
    }
    
    private func getCommentOwnerDetails(for comment: CommentModel, completion: @escaping (CurrentUser) -> Void) {
        guard  let userID = comment.userID else { return }
        
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
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        
        showIndicator(activityIndicator)
        commentService.deleteComment(for: bookID, ownerID: ownerID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            
            self.hideIndicator(self.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    // MARK: - Targets
    @objc private func refreshBookList() {
        commentList.removeAll()
        getComments()
    }
}
// MARK: - TableView Delegate
extension CommentsViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//  
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextMenuAction(for: .delete, forRowAtIndexPath: indexPath)
        let editAction = self.contextMenuAction(for: .edit, forRowAtIndexPath: indexPath)
        let commentOwnerID = commentList[indexPath.row].userID
        let currentUserID = Auth.auth().currentUser?.uid
        return commentOwnerID == currentUserID ? UISwipeActionsConfiguration(actions: [deleteAction, editAction]) : nil
    }
    
    private func contextMenuAction(for actionType: CategoryManagementAction,
                                   forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let comment = commentList[indexPath.row]
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
    
    private func makeDataSource() -> DataSource {
        dataSource = DataSource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                           for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: item)
            self?.getCommentOwnerDetails(for: item) { user in
                cell.configureUser(with: user)
            }
            return cell
        })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(commentList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - InputBar delegate
extension CommentsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        addComment(with: text, commentID: editedCommentID)
        self.inputBar.inputTextView.text = ""
        self.inputBar.inputTextView.resignFirstResponder()
        if !commentList.isEmpty {
            let indexPath = IndexPath(item: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}
