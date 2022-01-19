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
    private let validator: ValidatorProtocol
    private let bookCellConfigurator: CommentBookCellViewConfigure
    private let commentCellConfigurator: CommentCellConfigure?
    private let presenter: CommentPresenter
    
    private lazy var dataSource = makeDataSource()
    private var commentList: [CommentModel] = []
    private var book: Item?
    
    // MARK: - Initializer
    init(book: Item?,
         presenter: CommentPresenter,
         bookCellConfigurator: CommentBookCellViewConfigure,
         commentCellConfigurator: CommentCellConfigure,
         validator: ValidatorProtocol) {
        self.book = book
        self.presenter = presenter
        self.validator = validator
        self.bookCellConfigurator = bookCellConfigurator
        self.commentCellConfigurator = commentCellConfigurator
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
        presenter.view = self
        presenter.book = book
        IQKeyboardManager.shared.enableAutoToolbar = false
        mainView.tableView.dataSource = dataSource
        configureKeyboard()
        setDelegates()
        setTargets()
        addNavigationBarButtons()
        applySnapshot(animatingDifferences: false)
        presenter.getComments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            self?.presenter.getComments()
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
}
// MARK: - TableView Delegate
extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        switch section {
        case .book:
            return 150
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
                                          font: .lightSectionTitle)
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
                self.presenter.deleteComment(for: comment)
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
        presenter.editedCommentID = comment.uid
        mainView.inputBar.inputTextView.text = comment.comment
        mainView.inputBar.inputTextView.becomeFirstResponder()
    }
}

// MARK: - TableView Datasource
extension CommentsViewController {
    
    /// Create a data source with 3 sections
    ///  - Note: Section 1: The current book, Section 2: Today's comment, Section 3: Past comments.
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: mainView.tableView,
                                    cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            
            let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .book:
                if let item = item as? Item {
                    let reuseIdentifier = CommentsBookCell.reuseIdentifier
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                   for: indexPath) as? CommentsBookCell else {
                        return UITableViewCell() }
                    self?.bookCellConfigurator.setBookData(for: item) { data in
                        cell.configure(with: data)
                    }
                    return cell
                }
            case .today, .past:
                if let item = item as? CommentModel {
                    let reuseIdentifier = CommentTableViewCell.reuseIdentifier
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                                   for: indexPath) as? CommentTableViewCell else {
                        return UITableViewCell()
                    }
                    self?.commentCellConfigurator?.configure(cell, with: item)
                    return cell
                }
            case .none:
                return nil
            }
            return nil
        })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        mainView.emptyStateView.isHidden = !commentList.isEmpty
        
        var snapshot = Snapshot()
        snapshot.appendSections([.book])
        snapshot.appendItems([book], toSection: .book)
        
        let todayComments = commentList.filter({ validator.isTimestampToday(for: $0.timestamp) })
        snapshot.appendSections([.today])
        snapshot.appendItems(todayComments, toSection: .today)
        
        let pastComments = commentList.filter({ !validator.isTimestampToday(for: $0.timestamp) })
        snapshot.appendSections([.past])
        snapshot.appendItems(pastComments, toSection: .past)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
// MARK: - InputBar Delegate
extension CommentsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        presenter.addComment(with: text, commentID: presenter.editedCommentID)
        mainView.inputBar.inputTextView.text = ""
        mainView.inputBar.inputTextView.resignFirstResponder()
    }
}
// MARK: - EmptystateView Delegate
extension CommentsViewController: EmptyStateViewDelegate {
    func didTapButton() {
       mainView.inputBar.inputTextView.becomeFirstResponder()
    }
}
// MARK: - CommentPresenter Delegate
extension CommentsViewController: CommentsPresenterView {
    func updateCommentList(with comments: [CommentModel]) {
        self.commentList = comments
        applySnapshot(animatingDifferences: true)
    }

    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.showIndicator(self.mainView.activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.mainView.refresherControl.endRefreshing()
            self.hideIndicator(self.mainView.activityIndicator)
        }
    }
}
