//
//  BookListLayoutMenu.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/12/2021.
//

import UIKit

protocol BookListLayoutDelegate: AnyObject {
    func setLayoutFromMenu(for layout: GridItemSize)
    func orderList(by type: DocumentKey)
}

class BookListLayoutMenu {
    
    // MARK: - Property
    private weak var delegate: BookListLayoutDelegate?
   
    // MARK: - Initializer
    init(delegate: BookListLayoutDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public functions
    func configureLayoutMenu(for filterMenuIncluded: Bool) -> UIMenu {
        let menuItems = createMenuItems(filterOptions: filterMenuIncluded)
        return UIMenu(title: Text.ListMenu.bookListMenuTitle, image: nil, identifier: nil, children: menuItems)
    }
    
    func loadLayoutChoice() {
        let savedChoice = UserDefaults.standard.integer(forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        let gridSize = GridItemSize.allCases[savedChoice]
        delegate?.setLayoutFromMenu(for: gridSize)
    }
    
    // MARK: - Private functions
    private func createMenuItems(filterOptions: Bool) -> [UIMenuElement] {
        var items: [UIMenuElement] = []
        if filterOptions == true {
           items.append(filterMenu())
        }
     
        GridItemSize.allCases.forEach({ gridSize in
            let item = UIAction(title: gridSize.title, image: gridSize.image, handler: { [weak self] (_) in
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
            let item = UIAction(title: query.title, image: nil, handler: { [weak self] (_) in
                self?.delegate?.orderList(by: query.documentKey)
            })
            items.append(item)
        })
        return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: items)
    }
  
    private func saveLayoutChoice(for grid: CGFloat) {
        if let index = GridItemSize.allCases.firstIndex(where: { $0.rawValue == grid }) {
            UserDefaults.standard.set(index, forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        }
    }
}
