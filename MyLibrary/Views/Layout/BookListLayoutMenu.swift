//
//  BookListLayoutMenu.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/12/2021.
//

import UIKit

protocol BookListLayoutDelegate: AnyObject {
    func setLayoutFromMenu(for layout: GridItemSize)
}

class BookListLayoutMenu {
    
    // MARK: - Property
    private weak var delegate: BookListLayoutDelegate?
   
    // MARK: - Initializer
    init(delegate: BookListLayoutDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public functions
    func configureLayoutMenu() -> UIMenu {
        UIMenu(title: Text.Misc.sizeMenuTitle, image: nil, identifier: nil, children: createMenuItems())
    }
    
    func loadLayoutChoice() {
        let savedChoice = UserDefaults.standard.integer(forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        let gridSize = GridItemSize.allCases[savedChoice]
        delegate?.setLayoutFromMenu(for: gridSize)
    }
    
    // MARK: - Private functions
    private func createMenuItems() -> [UIMenuElement] {
        var items: [UIMenuElement] = []
        GridItemSize.allCases.forEach({ gridSize in
            let item = UIAction(title: gridSize.title, image: gridSize.image, handler: { [weak self] (_) in
                self?.delegate?.setLayoutFromMenu(for: gridSize)
                self?.saveLayoutChoice(for: gridSize.rawValue)
            })
            items.append(item)
        })
        return items
    }
  
    private func saveLayoutChoice(for grid: CGFloat) {
        if let index = GridItemSize.allCases.firstIndex(where: { $0.rawValue == grid }) {
            UserDefaults.standard.set(index, forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        }
    }
}
