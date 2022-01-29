//
//  Factory.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/01/2022.
//
import UIKit

protocol Factory {
    func makeHomeTabVC() -> UIViewController
    
    func makeAccountTabVC() -> UIViewController
    
    func makeCategoryVC(isSelecting: Bool,
                        bookCategories: [String],
                        newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController
    
    func makeBookLibraryVC(with query: BookQuery?, title: String?) -> UIViewController
    
    func makeAccountSetupVC(for type: AccountInterfaceType) -> UIViewController
    
    func makeNewBookVC(with book: ItemDTO?,
                       isEditing: Bool,
                       bookCardDelegate: BookCardDelegate?) -> UIViewController
    
    func makeBookCardVC(book: ItemDTO) -> UIViewController
    
    func makeBookDescriptionVC(description: String?, newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController
    
    func makeCommentVC(with book: ItemDTO?) -> UIViewController
    
    func makeBookCoverDisplayVC(with image: UIImage) -> UIViewController
    
    func makeNewCategoryVC(category: CategoryDTO?) -> UIViewController
    
    func makeListVC(for dataType: ListDataType,
                    selectedData: String?,
                    newBookDelegate: NewBookViewControllerDelegate?) -> UIViewController
    
    func makeBarcodeScannerVC(delegate: BarcodeScannerDelegate?) -> UIViewController
    func makeOnboardingVC() -> UIViewController
}

/// Default implementation to have default values.
extension Factory {
    func makeNewBookVC(with book: ItemDTO? = nil,
                       isEditing: Bool = false,
                       bookCardDelegate: BookCardDelegate? = nil) -> UIViewController {
        return makeNewBookVC(with: book,
                             isEditing: isEditing,
                             bookCardDelegate: bookCardDelegate)
    }

    func makeBookLibraryVC(with query: BookQuery? = .defaultAllBookQuery, title: String? = nil) -> UIViewController {
        return makeBookLibraryVC(with: query, title: title)
    }

    func makeNewCategoryVC(category: CategoryDTO? = nil) -> UIViewController {
        return makeNewCategoryVC(category: category)
    }

    func makeCategoryVC(isSelecting: Bool = false,
                        bookCategories: [String] = [],
                        newBookDelegate: NewBookViewControllerDelegate? = nil) -> UIViewController {
        return makeCategoryVC(isSelecting: isSelecting,
                              bookCategories: bookCategories,
                              newBookDelegate: newBookDelegate)
    }
}
