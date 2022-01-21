//
//  CommentCellConfiguration.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//
import UIKit

class CommentCellConfiguration {
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    private let formatter: FormatterProtocol
    private let commentService: CommentServiceProtocol
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         formatter: FormatterProtocol,
         commentService: CommentServiceProtocol) {
        self.imageRetriever = imageRetriever
        self.formatter = formatter
        self.commentService = commentService
    }
    
    private func getUserProfileImage(for user: UserModel, completion: @escaping(UIImage) -> Void) {
        imageRetriever.getImage(for: user.photoURL) { image in
            completion(image)
        }
    }
    
    private func getUser(for comment: CommentModel,
                         completion: @escaping(UserModel?) -> Void) {
        guard let userID = comment.userID else { return }
        
        self.commentService.getUserDetail(for: userID) { result in
            if case .success(let user) = result {
                completion(user)
            }
        }
    }
}
// MARK: - CommentCell presenter protocol
extension CommentCellConfiguration: CommentCellConfigure {
    
    func configure(_ cell: CommentTableViewCell, with comment: CommentModel) {
        cell.commentLabel.text = comment.comment
        if let timestamp = comment.timestamp {
            cell.dateLabel.text = self.formatter.formatTimeStampToRelativeDate(for: timestamp)
        }
        
        getUser(for: comment) { [weak self] user in
            guard let user = user else { return }
            cell.userNameLabel.text = user.displayName.capitalized
            
            self?.getUserProfileImage(for: user, completion: { image in
                cell.profileImageView.image = image
            })
        }
    }
}
