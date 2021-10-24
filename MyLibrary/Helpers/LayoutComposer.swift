//
//  LayoutCreator.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class LayoutComposer {
    
    private let interSectionSpace: CGFloat = 30
    private let sidesPadding: CGFloat = 13
    
    func makeSingleCellLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.3)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(CGFloat(20))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: interSectionSpace, trailing: 0)
        return section
    }
    
    func makeBookCardLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                            heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(20)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sidesPadding, bottom: interSectionSpace, trailing: sidesPadding)
        section.boundarySupplementaryItems = [addHeader()]
        return section
    }
    
    func makeVerticalLayoutSection(numberItems: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(0.3)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1)),
            subitem: item,
            count: numberItems
        )
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sidesPadding, bottom: interSectionSpace, trailing: sidesPadding)
        section.boundarySupplementaryItems = [addHeader()]
        return section
    }
    
    func makeGridLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3)),
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sidesPadding, bottom: interSectionSpace, trailing: sidesPadding)
        return section
    }
    
    func addHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                           elementKind: HeaderSupplementaryView.kind, alignment: .top)
    }
    
    func composeHomeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch HomeCollectionViewSections(rawValue: sectionIndex) {
            case .reading:
                return self?.makeSingleCellLayoutSection()
            case .newEntry:
                return self?.makeBookCardLayoutSection()
            case .lastRead:
                return self?.makeVerticalLayoutSection(numberItems: 3)
            case nil:
                return nil
            }
        }
    }
    
    func composeBookLibraryLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
           return self?.makeGridLayoutSection()
        }
    }
}
