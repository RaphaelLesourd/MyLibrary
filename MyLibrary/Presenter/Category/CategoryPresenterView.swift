//
//  CategoryPresenterView.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//
import Foundation

protocol CategoryPresenterView: AcitivityIndicatorProtocol, AnyObject {
    func applySnapshot(animatingDifferences: Bool)
    func highlightCell(at indexPath: IndexPath)
    func displayDeleteAlert(for category: CategoryModel)
    func presentNewCategoryController(editing: Bool, for category: CategoryModel?)
}
