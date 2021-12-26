//
//  HomeControllerLayout.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/11/2021.
//

import UIKit

class HomeViewControllerLayout {
    
    // Categories section layout
    private func makeCategoryLayoutSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                          heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                       subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                          top: nil,
                                                          trailing: .fixed(5),
                                                          bottom: nil)
        return createSection(with: group, horizontal: true)
    }
    
    // Horizontal scroll single cell
    private func makeHorizontalScrollLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 10)
        let size = NSCollectionLayoutSize(widthDimension: .absolute(130),
                                          heightDimension: .absolute(190))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                       subitem: item, count: 1)
        group.interItemSpacing = .fixed(10)
        return createSection(with: group, horizontal: true)
    }
    
    // Horizontal scroll layout, cell with description
    private func makeBookDetailLayoutSection(numberItems: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 30)
        let desiredWidth: CGFloat = 600
        let itemCount = environment.container.effectiveContentSize.width / desiredWidth
        let fractionWidth: CGFloat = 1 / (itemCount.rounded())
        print(fractionWidth)
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionWidth - 0.1),
                                          heightDimension: .absolute(290))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                     subitem: item,
                                                     count: numberItems)
        group.interItemSpacing = .fixed(15)
        return createSection(with: group, horizontal: true)
    }
    
    private func addHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                           alignment: .top)
    }
    
    private func createSection(with group: NSCollectionLayoutGroup, horizontal: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        if horizontal == true {
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        }
        section.contentInsets = .init(top: 10,
                                      leading: 7,
                                      bottom: 40,
                                      trailing: 7)
        section.boundarySupplementaryItems = [addHeader()]
        return section
    }
}
// MARK: - Layout composer protocol
extension HomeViewControllerLayout: HomeLayoutComposer {
    func setCollectionViewLayout(dataSource: UICollectionViewDiffableDataSource<HomeCollectionViewSections,
                                 AnyHashable>) -> UICollectionViewLayout {
     
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environement in
            let section = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch section {
            case .categories:
                return self?.makeCategoryLayoutSection()
            case .newEntry:
                return self?.makeHorizontalScrollLayoutSection()
            case .favorites:
                return self?.makeHorizontalScrollLayoutSection()
            case .recommanding:
                return self?.makeBookDetailLayoutSection(numberItems: 3, environment: environement)
            }
        }
        return layout
    }
}
