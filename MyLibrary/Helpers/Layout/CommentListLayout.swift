//
//  CommentListLayout.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import Foundation
import UIKit

class CommentListLayout {
 
    private  func makeVerticalGridLayoutSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                                          heightDimension: NSCollectionLayoutDimension.estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 50
        section.contentInsets = .init(top: 5, leading: 16, bottom: 20, trailing: 16)
        return section
    }
}

extension CommentListLayout: LayoutComposer {
    func setCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.makeVerticalGridLayoutSection()
        }
    }
}
