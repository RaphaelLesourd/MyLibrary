//
//  BookListLayoutMenu.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/12/2021.
//

import UIKit

class BookListMenu {
    
    // MARK: - Property
    private weak var delegate: BookListMenuDelegate?
   
    // MARK: - Initializer
    init(delegate: BookListMenuDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public functions
    func configureLayoutMenu(for filterMenuIncluded: Bool) -> UIMenu {
        let menuItems = createMenuItems(filterOptions: filterMenuIncluded)
        return UIMenu(title: Text.ListMenu.bookListMenuTitle,
                      image: nil,
                      identifier: nil,
                      children: menuItems)
    }
    
    func loadLayoutChoice() {
        let savedChoice = UserDefaults.standard.integer(forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        let gridSize = BookGridSize.allCases[savedChoice]
        delegate?.setLayoutFromMenu(for: gridSize)
    }
    
    // MARK: - Private functions
    private func createMenuItems(filterOptions: Bool) -> [UIMenuElement] {
        var items: [UIMenuElement] = []
        if filterOptions == true {
           items.append(filterMenu())
        }
     
        BookGridSize.allCases.forEach({ gridSize in
            let item = UIAction(title: gridSize.title,
                                image: gridSize.image,
                                handler: { [weak self] (_) in
                self?.delegate?.setLayoutFromMenu(for: gridSize)
                self?.saveLayoutChoice(for: gridSize.rawValue)
            })
            items.append(item)
        })
        return items
    }
    
    private func filterMenu() -> UIMenu {
        var items: [UIMenuElement] = []
        QueryType.allCases.forEach({ query in
            let item = UIAction(title: query.title,
                                image: nil,
                                handler: { [weak self] (_) in
                self?.delegate?.orderList(by: query.documentKey)
            })
            items.append(item)
        })
        return UIMenu(title: "",
                      image: nil,
                      identifier: nil,
                      options: .displayInline,
                      children: items)
    }
  
    private func saveLayoutChoice(for grid: CGFloat) {
        if let index = BookGridSize.allCases.firstIndex(where: { $0.rawValue == grid }) {
            UserDefaults.standard.set(index, forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        }
    }
}
