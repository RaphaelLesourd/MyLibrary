//
//  BookListLayoutMenu.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/12/2021.
//

import UIKit

protocol BookListLayoutDelegate: AnyObject {
    func setLayout(for layout: GridItemSize)
}

class BookListLayoutMenu {
    
    // MARK: - Property
    weak var delegate: BookListLayoutDelegate?
    
    // MARK: - Initializer
    init(delegate: BookListLayoutDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public functions
    func configureLayoutMenu() -> UIMenu {
        UIMenu(title: Text.Misc.sizeMenuTitle, image: nil, identifier: nil, options: [.displayInline], children: addItemAction())
    }
    
    func loadLayoutChoice() {
        let savedChoice = UserDefaults.standard.integer(forKey: UserDefaultKey.bookListMenuLayout.rawValue)
        let gridSize = GridItemSize.allCases[savedChoice]
        delegate?.setLayout(for: gridSize)
    }
    
    // MARK: - Private functions
    private func addItemAction() -> [UIMenuElement] {
        var items: [UIMenuElement] = []
        GridItemSize.allCases.forEach({ gridSize in
            let item = UIAction(title: gridSize.title, image: gridSize.image, handler: { [weak self] (_) in
                self?.delegate?.setLayout(for: gridSize)
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
