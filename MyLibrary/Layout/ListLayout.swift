//
//  ListLayout.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/11/2021.
//

import UIKit

enum GridItemSize: CGFloat, CaseIterable {
    case half = 0.5
    case third = 0.33333
    case quarter = 0.25
    
    var title: String {
        switch self {
        case .half:
            return "Par deux"
        case .third:
            return "Par trois"
        case .quarter:
            return "Par quatre"
        }
    }
    
    var image: UIImage {
        switch self {
        case .half:
            return Images.gridHalfLayout
        case .third:
            return Images.gridThirdLayout
        case .quarter:
            return Images.gridQuarterLayout
        }
    }
    
}

class ListLayout {
 
    private  func makeVerticalGridLayoutSection(gridItemSize: GridItemSize) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(gridItemSize.rawValue), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2.5, bottom: 17, trailing: 2.5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(gridItemSize.rawValue * 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
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
// MARK: - Layout composer protocol
extension ListLayout: LayoutComposer {
    
    func setCollectionViewLayout(gridItemSize: GridItemSize) -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.makeVerticalGridLayoutSection(gridItemSize: gridItemSize)
        }
    }
}
