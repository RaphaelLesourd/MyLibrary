//
//  ListLayout.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/11/2021.
//

import Foundation
import UIKit

class ListLayout {
 
    private  func makeVerticalGridLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 17, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.65)),
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 7, bottom: 0, trailing: 7)
        section.boundarySupplementaryItems = [addFooter()]
        return section
    }
 
    private func addFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerItemSize,
                                                           elementKind: UICollectionView.elementKindSectionFooter,
                                                           alignment: .bottom)
    }
}

extension ListLayout: LayoutComposer {
    func setCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.makeVerticalGridLayoutSection()
        }
    }
}
