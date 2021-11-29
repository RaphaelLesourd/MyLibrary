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

class CommentsViewController: UIViewController {
    
    // MARK: - Properties
    typealias Snapshot   = NSDiffableDataSourceSnapshot<SingleSection, CommentModel>
    typealias DataSource = UICollectionViewDiffableDataSource<SingleSection, CommentModel>
    private lazy var dataSource = makeDataSource()
    
    private let mainView      = CollectionView()
    private let commentService: CommentServiceProtocol
    private let imageLoader   : ImageLoaderProtocol
    
    private var keyboardManager = KeyboardManager()
    private var footerView      = LoadingFooterSupplementaryView()
    private var inputBar        = InputBarAccessoryView()
    private var commentList     : [CommentModel] = []
    private var layoutComposer  : LayoutComposer
    
    var book: Item?
    
    // MARK: - Initializer
    init(commentService: CommentServiceProtocol, imageLoader: ImageLoaderProtocol, layoutComposer: LayoutComposer) {
        self.commentService = commentService
        self.layoutComposer = layoutComposer
        self.imageLoader    = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view  = mainView
        title = "Commentaires"
        view.backgroundColor = .viewControllerBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
        configureInputBar()
        configureCollectionView()
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
        let activityIndicactorButton = UIBarButtonItem(customView: mainView.activityIndicator)
        navigationItem.rightBarButtonItems = [activityIndicactorButton]
    }
    
    private func configureCollectionView() {
        let layout = layoutComposer.setCollectionViewLayout()
        mainView.collectionView.collectionViewLayout = layout
        mainView.collectionView.autoresizingMask = [.flexibleHeight]
        mainView.collectionView.register(cell: CommentCollectionViewCell.self)
        mainView.collectionView.delegate   = self
        mainView.collectionView.dataSource = dataSource
    }
    
    private func configureRefresherControl() {
        mainView.refresherControl.addTarget(self, action: #selector(refreshBookList), for: .valueChanged)
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
        keyboardManager.bind(to: mainView.collectionView)
    }
    
    // MARK: - Api call
    private func getComments() {
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
            case .failure(let error):
                self.presentAlertBanner(as: .error, subtitle: error.description)
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
    
    private func addComment(with comment: String) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        
        showIndicator(mainView.activityIndicator)
        commentService.addComment(for: bookID, ownerID: ownerID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            
            self.hideIndicator(self.mainView.activityIndicator)
            if let error = error {
                self.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func deleteComment(for comment: CommentModel) {
        guard let bookID = book?.bookID,
              let ownerID = book?.ownerID else { return }
        
        showIndicator( mainView.activityIndicator)
        commentService.deleteComment(for: bookID, ownerID: ownerID, comment: comment) { [weak self] error in
            guard let self = self else { return }
            
            self.hideIndicator(self.mainView.activityIndicator)
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
// MARK: - CollectionView Delegate
extension CommentsViewController: UICollectionViewDelegate { }

// MARK: - CollectionView Datasource
extension CommentsViewController {
    private func makeDataSource() -> DataSource {
        dataSource = DataSource(collectionView: mainView.collectionView,
                                cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell: CommentCollectionViewCell = collectionView.dequeue(for: indexPath)
            self?.getCommentOwnerDetails(for: item) { user in
                cell.configureUser(with: user)
                cell.configure(with: item)
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
        addComment(with: text)
        self.inputBar.inputTextView.text = ""
        self.inputBar.inputTextView.resignFirstResponder()
        let indexPath = IndexPath(item: 0, section: 0)
        mainView.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}
