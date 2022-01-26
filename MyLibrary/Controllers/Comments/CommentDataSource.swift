//
//  CommentDataSource.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//

import UIKit

class CommentDataSource: UITableViewDiffableDataSource<CommentsSection, AnyHashable> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
