//
//  CommentDataSource.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//

import UIKit
import FirebaseAuth

class CommentDataSource: UITableViewDiffableDataSource<CommentsSection, AnyHashable> {
  
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let comment = self.itemIdentifier(for: indexPath) as? CommentModel else { return false }
        return comment.userID == Auth.auth().currentUser?.uid
    }
}
