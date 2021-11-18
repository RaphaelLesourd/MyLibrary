//
//  LayoutCreator.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class LayoutComposer {
    
    // MARK: - Properties
    private let interSectionSpace: CGFloat = 40
    
    // MARK: - Section Layouts
    // Categories horizontal scroll layout
    private func makeCategoryLayoutSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitems: [item]
        )
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(5), bottom: nil)
        return createSection(with: group, horizontal: true)
    }
    
    // Horizontal scroll single cell
    private func makeHorizontalScrollLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(130), heightDimension: .absolute(230)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(10)
        return createSection(with: group, horizontal: true)
    }
    
    // Horizontal scroll layout, cell with description
    private func makeBookDetailLayoutSection(numberItems: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 30)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(290)),
            subitem: item,
            count: numberItems
        )
        group.interItemSpacing = .fixed(10)
        return createSection(with: group, horizontal: true)
    }
    
    // Vertical scroll grid layout with 3 cells per row
    private  func makeVerticalGridLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
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
    
    // MARK: - Section
    private func createSection(with group: NSCollectionLayoutGroup, horizontal: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        if horizontal == true {
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        }
        section.contentInsets = .init(top: 10, leading: 7, bottom: interSectionSpace, trailing: 7)
        section.boundarySupplementaryItems = [addHeader()]
        return section
    }
    
    // MARK: - Header&Footer
    private func addHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                           alignment: .top)
    }
    
    private func addFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerItemSize,
                                                           elementKind: UICollectionView.elementKindSectionFooter,
                                                           alignment: .bottom)
    }
    
    // MARK: - Layouts
    func composeHomeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch HomeCollectionViewSections(rawValue: sectionIndex) {
            case .categories:
                return self?.makeCategoryLayoutSection()
            case .newEntry:
                return self?.makeHorizontalScrollLayoutSection()
            case .favorites:
                return self?.makeHorizontalScrollLayoutSection()
            case .recommanding:
                return self?.makeBookDetailLayoutSection(numberItems: 3)
            case nil:
                return nil
            }
        }
    }
    
    func composeBookLibraryLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.makeVerticalGridLayoutSection()
        }
    }

}
