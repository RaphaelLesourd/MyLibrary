//
//  OnboardingLayout.swift
//  MyLibrary
//
//  Created by Birkyboy on 13/01/2022.
//

import UIKit

class OnboardingLayout {
 
    private  func makeVerticalGridLayoutSection(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
// MARK: - Layout composer protocol
extension OnboardingLayout: OnboardingLayoutComposer {
    
    func setCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environement in
            return self?.makeVerticalGridLayoutSection(environment: environement)
        }
    }
}
