//
//  CategoriesDataSource.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/01/2022.
//

import UIKit

class CategoryDataSource: UITableViewDiffableDataSource<SingleSection, CategoryDTO> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
