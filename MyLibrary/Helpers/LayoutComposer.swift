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
    
    private func makeCategoryLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(110), heightDimension: .absolute(40)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(10)
        return createSection(with: group, direction: true)
    }
    
    private func makeBookCardLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.29), heightDimension: .fractionalHeight(0.3)),
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(20)
        return createSection(with: group, direction: true)
    }
    
    private func makeVerticalLayoutSection(numberItems: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)),
            subitem: item,
            count: numberItems
        )
        group.interItemSpacing = .fixed(20)
        return createSection(with: group, direction: true)
    }
    
    private  func makeGridLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28),
                                                                             heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.31)),
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(15)
        return createSection(with: group, direction: false)
    }
    
    private func createSection(with group: NSCollectionLayoutGroup, direction: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        if direction == true {
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        }
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: sidesPadding, bottom: interSectionSpace, trailing: sidesPadding)
        section.boundarySupplementaryItems = [addHeader()]
        return section
    }
    
    private func addHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                           elementKind: HeaderSupplementaryView.kind, alignment: .top)
    }
    
    func composeHomeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch HomeCollectionViewSections(rawValue: sectionIndex) {
            case .categories:
                return self?.makeCategoryLayoutSection()
            case .recommanding, .newEntry:
                return self?.makeBookCardLayoutSection()
            case .favorites:
                return self?.makeVerticalLayoutSection(numberItems: 2)
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
    
    func composeSearchCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch SearchCollectionViewSections(rawValue: sectionIndex) {
            case .librarySearch, .apiSearch:
                return self?.makeVerticalLayoutSection(numberItems: 2)
            case nil:
                return nil
            }
        }
    }
}
