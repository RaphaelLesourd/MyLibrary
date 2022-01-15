//
//  CommentCellConfiguration.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/12/2021.
//

class CommentCellConfiguration {
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    private let formatter: FormatterProtocol
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         formatter: FormatterProtocol) {
        self.imageRetriever = imageRetriever
        self.formatter = formatter
    }
}
// MARK: - CommentCell presenter protocol
extension CommentCellConfiguration: CommentCellConfigure {
      
    func configure(_ cell: CommentTableViewCell, with comment: CommentModel) {
        cell.commentLabel.text = comment.comment
        if let timestamp = comment.timestamp {
            cell.dateLabel.text = self.formatter.formatTimeStampToRelativeDate(for: timestamp)
        }
    }
    
    func setUserDetails(for cell: CommentTableViewCell, with user: UserModel) {
        cell.userNameLabel.text = user.displayName.capitalized
        imageRetriever.getImage(for: user.photoURL) { image in
            cell.profileImageView.image = image
        }
    }
}
    
