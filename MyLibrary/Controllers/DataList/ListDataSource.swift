//
//  ListDataSource.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//

import UIKit

class ListDataSource: UITableViewDiffableDataSource<ListSection, ListRepresentable> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
