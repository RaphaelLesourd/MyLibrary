//
//  HomeControllerLayout.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/11/2021.
//

import UIKit

class HomeTabLayout {
    
    typealias DataSource = UICollectionViewDiffableDataSource<HomeCollectionViewSections, AnyHashable>
    
    private let device = UIDevice.current.userInterfaceIdiom
    private let edgeSpacing: CGFloat = 7
    
    // Categories section layout
    private func makeCategoryLayoutSection() -> NSCollectionLayoutSection {
       
        let size = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                          heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                       subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                          top: nil,
                                                          trailing: .fixed(5),
                                                          bottom: nil)
        return createSection(with: group,
                             scrollType: .continuous)
    }
    
    private func makeUserLayoutSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .absolute(80),
                                          heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                       subitems: [item])
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil,
                                                          top: nil,
                                                          trailing: .fixed(10),
                                                          bottom: nil)
        return createSection(with: group,
                             spacing: -10,
                             scrollType: .continuousGroupLeadingBoundary)
    }
    
    // Horizontal scroll single cell
    private func makeHorizontalScrollLayoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 10)
        let iphoneSize = NSCollectionLayoutSize(widthDimension: .absolute(130),
                                          heightDimension: .absolute(190))
        let ipadSize = NSCollectionLayoutSize(widthDimension: .absolute(150),
                                          heightDimension: .absolute(210))
        let size = device == .pad ? ipadSize : iphoneSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                       subitem: item,
                                                       count: 1)
        group.interItemSpacing = .fixed(10)
        return createSection(with: group,
                             scrollType: .continuousGroupLeadingBoundary)
    }
    
    // Horizontal scroll layout, cell with description
    private func makeBookDetailLayoutSection(numberItems: Int,
                                             environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.withEntireSize()
        item.contentInsets = .init(top: 0,
                                   leading: 0,
                                   bottom: 0,
                                   trailing: 30)
        let desiredWidth: CGFloat = 600
        let itemCount = environment.container.effectiveContentSize.width / desiredWidth
        let fractionWidth: CGFloat = 1 / (itemCount.rounded())
        
        let height: CGFloat = device == .pad ? 500 : 290
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionWidth - 0.1),
                                          heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                     subitem: item,
                                                     count: numberItems)
        group.interItemSpacing = .fixed(15)
        return createSection(with: group,
                             scrollType: .continuousGroupLeadingBoundary)
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .estimated(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                           elementKind: UICollectionView.elementKindSectionHeader,
                                                           alignment: .top)
    }
    
    private func createSection(with group: NSCollectionLayoutGroup,
                               spacing: CGFloat = 40,
                               scrollType: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollType
        section.contentInsets = .init(top: 10,
                                      leading: edgeSpacing,
                                      bottom: spacing,
                                      trailing: edgeSpacing)
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }
}
// MARK: - Layout composer protocol
extension HomeTabLayout: HomeLayoutComposer {
    
    func setCollectionViewLayout(dataSource: DataSource) -> UICollectionViewLayout {
     
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
            case .users:
                return self?.makeUserLayoutSection()
            }
        }
        return layout
    }
}
