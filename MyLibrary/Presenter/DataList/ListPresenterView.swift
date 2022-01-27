//
//  ListPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol ListPresenterView: AnyObject {
    func setTitle(as title: String)
    func highlightCell(for item: DataListUI)
    func setLanguage(with code: String)
    func setCurrency(with code: String)
    func applySnapshot(animatingDifferences: Bool)
    func reloadRow(for item: DataListUI)
}
