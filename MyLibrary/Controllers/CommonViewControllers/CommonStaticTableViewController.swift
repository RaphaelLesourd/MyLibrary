//
//  StaticTableViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 02/11/2021.
//

import Foundation
import UIKit

class CommonStaticTableViewController: UITableViewController {
   
    // MARK: - Properties
    var sections: [[UITableViewCell]] = [[]]
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureTableView()
    }

    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor    = .viewControllerBackgroundColor
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    /// Create a default cell user to open another controller/
    /// - Parameter text: Cell title
    /// - Returns: cell
    func createDefaultCell(with text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        cell.backgroundColor = .tertiarySystemBackground
        cell.accessoryType   = .disclosureIndicator
        return cell
    }
}

// MARK: - TableView DataSource & Delegate
extension CommonStaticTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section][indexPath.row]
    }
}
