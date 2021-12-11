//
//  StaticTableViewController.swift
//  MyLibrary
//
//  Created by Birkyboy on 02/11/2021.
//

import UIKit

class StaticTableViewController: UITableViewController {
    
    // MARK: - Properties
    var sections: [[UITableViewCell]] = [[]]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewControllerBackgroundColor
        configureTableView()
    }
    
    /// Create a default cell user to open another controller/
    /// - Parameter text: Cell title
    /// - Returns: cell
    func createDefaultCell(with text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = text
        cell.backgroundColor = .tertiarySystemBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Setup
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .viewControllerBackgroundColor
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
}

// MARK: - TableView DataSource & Delegate
extension StaticTableViewController {
   
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
