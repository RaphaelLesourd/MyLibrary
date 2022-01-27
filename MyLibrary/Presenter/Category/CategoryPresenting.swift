//
//  CategoryPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol CategoryPresenting {
    var view: CategoryPresenterView? { get set }
    var categories: [CategoryModel] { get set }
    var selectedCategories: [String] { get set }
    func getCategoryList()
    func deleteCategory(for category: CategoryModel)
    func filterSearchedCategories(for searchText: String)
    func highlightBookCategories(for section: Int)
    func addSelectedCategory(at index: Int)
    func removeSelectedCategory(from index: Int)
    func presentSwipeAction(for action: CellSwipeActionType, at index: Int)
}
