//
//  NewCategoryPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol NewCategoryPresenting {
    var view: NewCategoryPresenterView? { get set }
    var defaultColors: [String] { get }
    func displayCategoryColor(with colorHex: String?)
    func saveCategory(with name: String?, and colorHex: String, for category: CategoryModel?)
}
