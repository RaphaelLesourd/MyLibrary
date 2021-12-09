//
//  LayoutCreator.swift
//  MyLibrary
//
//  Created by Birkyboy on 22/10/2021.
//

import UIKit

protocol LayoutComposer {
    func setCollectionViewLayout() -> UICollectionViewLayout
}

protocol HomeLayoutComposer {
    func setCollectionViewLayout(dataSource: UICollectionViewDiffableDataSource<HomeCollectionViewSections, AnyHashable>) -> UICollectionViewLayout
}
