//
//  Factory.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import UIKit

protocol Factory {
    func makeAccountTabViewcontroller() -> UIViewController
  
    func makeCategoryVC(settingCategory: Bool,
                        bookCategories: [String],
                        newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController
   
    func makeBookListVC(with query: BookQuery) -> UIViewController
   
    func makeAccountSetupController(for type: AccountInterfaceType) -> UIViewController
   
    func makeNewBookVC(with book: Item?,
                       isEditing: Bool,
                       bookCardDelegate: BookCardDelegate?) -> UIViewController
  
    func makeBookCardVC(book: Item, type: SearchType?,
                        factory: Factory) -> UIViewController
  
    func makeBookDescriptionVC(description: String?,
                               newBookDelegate: NewBookViewControllerDelegate) -> UIViewController
  
    func makeCommentVC(with book: Item?) -> UIViewController
  
    func makeBookCoverDisplayVC(with image: UIImage) -> UIViewController
  
    func makeNewCategoryVC(editing: Bool,
                           category: CategoryModel?) -> UIViewController
  
    func makeListViewController(for dataType: ListDataType,
                                selectedData: String?,
                                newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController
}
