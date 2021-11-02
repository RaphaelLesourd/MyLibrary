//
//  LayoutCreator.swift
//  MyBookLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import Foundation
import UIKit

class LayoutComposer {
    
    // MARK: - Properties
    private let interSectionSpace: CGFloat = 30
    
    // MARK: - Section Layouts
    // Categories horizontal scroll layout
    private func makeCategoryLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 15)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(110), heightDimension: .absolute(40)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(10)
        return createSection(with: group, horizontal: true)
    }
    
    // Horizontal scroll single cell
    private func makeHorizontalBookCardLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 15)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(200)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(20)
        return createSection(with: group, horizontal: true)
    }
    
    // Horizontal scroll layout of details cell
    private func makeVerticalWithDetailLayoutSection(numberItems: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 30)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)),
            subitem: item,
            count: numberItems
        )
        group.interItemSpacing = .fixed(20)
        return createSection(with: group, horizontal: true)
    }
    
    // Vertical scroll grid layout with 3 cells per row
    private  func makeVerticalGridLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .absolute(250))
        item.contentInsets = .uniform(size: 0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)),
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [addFooter()]
        return section
    }
    
    // MARK: - Section
    private func createSection(with group: NSCollectionLayoutGroup, horizontal: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        if horizontal == true {
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        }
        section.contentInsets = .uniform(size: 10)
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
            case .recommanding, .newEntry:
                return self?.makeHorizontalBookCardLayoutSection()
            case .favorites:
                return self?.makeVerticalWithDetailLayoutSection(numberItems: 2)
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
